Redis-RPC
=======

## DESCRIPTION

Redis RPC is a library for executing remote procedure calls through queues (lists) in redis.
The main purpose of this is to allow for queueing service requests and allow for downtime of
internal services.

This is a work in progress. I can change whatever I want still.

## INSTALLATION

### RubyGems

    $ [sudo] gem install redis_rpc

### GitHub

    $ git clone git://github.com/raykrueger/redis_rpc.git
    $ cd redis_rpc && gem build redis_rpc.gemspec
    $ gem install redis_rpc-<version>.gem

## USAGE

### SERVER

Create a redis connection, define your service class, and start the server.
The call to `RedisRpc::Server.run` will block indefinitely.

    require 'redis_rpc/server'

    redis = Redis.connect(:url => 'redis://127.0.0.1:6379/9')
    
    class Service
      def say_hello
        "Hello World"
      end
    
      def boom
        raise "BOOM"
      end
    end
    
    RedisRpc::Server.run(Service.new, :redis => redis)

### CLIENT
Establishing a client is very similar. Establish a connection to redis and hand it to the client
factory. The `service` name you pass should be the class name of the service you wish to call
on the server side.

Note that the client needs a source for random data (to name the response queue). Any of the
the following will work...
`require 'securerandom'` #ruby 1.9
`require 'openssl'`
`require 'active_support/secure_random'`

    require 'redis_rpc/client'
    require 'openssl'
    
    redis = Redis.connect(:url => 'redis://127.0.0.1:6379/9')
    
    client = RedisRpc::Client.new('Service', :redis => redis)
    
    client.say_hello
    client.boom

## LIMITATIONS
Currently all marshalling is handled by msgpack. This means it is extremely fast, but limited
in what it can handle. All basic ruby types are handled automatically (true, false, nil, FixNum,
BigNum, String, Array, Hash). This means that method arguments, and method results have to be
rather simple right now.

## CONTRIBUTE

If you'd like to hack on redis_rpc, start by forking the repo on GitHub:

https://github.com/raykrueger/redis_rpc

The best way to get your changes merged back into core is as follows:

1. Clone down your fork
1. Create a thoughtfully named topic branch to contain your change
1. Hack away
1. Add tests and make sure everything still passes by running `rake`
1. If you are adding new functionality, document it in the README
1. Do not change the version number, we will do that on our end
1. If necessary, rebase your commits into logical chunks, without errors
1. Push the branch up to GitHub
1. Send a pull request for your branch
