#!/usr/bin/env rake
require 'rake/testtask'
require "bundler/gem_tasks"

task :default => [:test]

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/*_spec.rb']
end
