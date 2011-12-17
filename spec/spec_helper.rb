require 'rubygems'
require 'bundler'
Bundler.setup(:default, :development, :test)
require 'minitest/autorun'

require 'redis_rpc'
