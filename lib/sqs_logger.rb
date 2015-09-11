require 'rack'
require 'aws-sdk'
require 'json'

require 'sqs_logger/version'
require 'sqs_logger/sqs_writer'
require 'sqs_logger/logger'

module SqsLogger
  def self.setup
    yield(config)
  end

  def self.config
    @config ||= Config.new
  end

  class Config
    attr_accessor :sqs_queue_name, :application_name
  end
end
