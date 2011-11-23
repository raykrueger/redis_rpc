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
      while true
        requests = Hash[*@redis.blpop(@services.keys, 0)]

        requests.each_pair do |name, msg|
          args = MessagePack.unpack(msg)
          @services[name].send(*args)
        end
      end
    end
    
    def self.run(*args)
      new(*args).run
    end

  end
end
