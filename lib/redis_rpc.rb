require "redis_rpc/version"
require 'msgpack'
require 'logger'

module RedisRpc

  @@random_source = nil
  @@logger = nil

  module Packed
    def to_msgpack
      hash = {}
      self.instance_variables.each do |var| 
        hash[var.to_s.delete("@")] = self.instance_variable_get(var)
      end
      hash.to_msgpack
    end
  end

  class Response
    include Packed
    attr_reader :result, :exception_message

    def initialize(result)
      if result.kind_of? Exception
        @exception_message = result.to_s
      else
        @result = result
      end
    end
  end

  def self.random_source
    unless @@random_source
      if defined?(::SecureRandom)
        @@random_source = ::SecureRandom
      elsif defined?(::OpenSSL::Random)
        @@random_source = ::OpenSSL::Random
      elsif defined?(::ActiveSupport::SecureRandom)
        @@random_source = ::ActiveSupport::SecureRandom
      else
        raise "Cannot use Ruby 1.9 SecureRandom, ActiveSupport::SecureRandom, or OpenSSL::Random. Please require at least one of those."
      end
    end
    @@random_source
  end

  def self.random_source=(random)
    @@random_source = random
  end

  def self.random_id
    self.random_source.random_bytes(32).unpack('H*').first
  end

  def self.logger=(logger)
    @@logger = logger
  end
  
  def self.logger
    unless @@logger
      @@logger = Logger.new(STDOUT)
      STDOUT.sync = true
    end
    @@logger
  end

end
