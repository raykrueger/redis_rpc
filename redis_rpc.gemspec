# -*- encoding: utf-8 -*-
require File.expand_path('../lib/redis_rpc/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ray Krueger"]
  gem.email         = ["raykrueger@gmail.com"]
  gem.description   = %q{Library for queuing remote procedure calls through redis}
  gem.summary       = %q{http://github.com/raykrueger/ruby_smpp}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "redis_rpc"
  gem.require_paths = ["lib"]
  gem.version       = RedisRpc::VERSION

  gem.add_dependency "redis", "~> 2.2"
  
end
