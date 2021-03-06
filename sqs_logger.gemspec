# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sqs_logger/version'

Gem::Specification.new do |spec|
  spec.name          = "sqs_logger"
  spec.version       = SqsLogger::VERSION
  spec.authors       = ["Josh Greenwood", "Dustin Tinney"]
  spec.email         = ["joshua.t.greenwood@gmail.com", "tinney@gmail.com"]

  spec.summary       = %q{Rack middlware for sending logs to Amazon's SQS}
  spec.description   = %q{Rack middlware for sending logs to Amazon's SQS}
  spec.homepage      = "http://www.github.com/hendrick/sqs-logger"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "aws-sdk", "~> 2.1"
  spec.add_runtime_dependency "rack", "~> 1.5.2"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "fake_sqs", "~> 0.3"
  spec.add_development_dependency "rake", "~> 10.0"
end
