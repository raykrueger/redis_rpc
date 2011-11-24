require 'redis_rpc'
require 'redis'

module RedisRpc
  class Client

    def initialize(service_name, options={})
      @service_name = service_name
      @redis = options[:redis] || Redis.connect
      @timeout = options[:timeout] || 10
    end

    def method_missing(method_name, *args)
      request_id = RedisRpc.random_id
      request = {
        :request_id => request_id,
        :payload => [method_name, *args],
      }
      response_key = "#{@service_name}:#{request_id}"

      @redis.rpush(@service_name, request.to_msgpack)
      response = @redis.blpop(response_key, @timeout)
      @redis.del(response_key)

      response = MessagePack.unpack(response[1]) if response

      if response
        if response['exception_message']
          raise response['exception_message']
        else
          return response['result']
        end
      end
    end

  end
end

