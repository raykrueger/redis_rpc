require 'redis_rpc'
require 'redis'
require 'logger'

module RedisRpc
  class Server

    def initialize(*services)
      options = {}
      if (services.last.is_a? Hash)
        options = services.pop
      end

      @services = {}
      services.each do |service|
        @services[service.class.name] = service
      end
      @redis = options[:redis] || Redis.connect
    end

    def run
      while true #blpop blocks anyway, so just keep running till we're killed
        requests = Hash[*@redis.blpop(@services.keys, 0)]

        requests.each_pair do |name, msg|
          request = MessagePack.unpack(msg)
          request_id = request['request_id']
          args = request['payload']

          begin
            result = @services[name].send(*args)
          rescue => e
            RedisRpc.logger.error(%Q|#{e.message}\n#{e.backtrace.join("\n")}|)
            result = e
          end

          response = Response.new(result)

          @redis.lpush "#{name}:#{request_id}", response.to_msgpack
        end
      end
    end
    
    def self.run(*args)
      new(*args).run
    end

  end
end
