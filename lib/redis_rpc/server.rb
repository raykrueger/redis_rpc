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
      @block_wait = options[:block_wait] || 5
    end

    def run(&block)
      RedisRpc.logger.info "RedisRpc listening to #{@services.keys.join(', ')}"
      while (block_given? ? block.call : true)
        requests = @redis.blpop(@services.keys, @block_wait)

        if requests
          requests = Hash[*requests]
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
    end

    def self.run_while(*args, &block)
      new(*args).run(&block)
    end

  end
end
