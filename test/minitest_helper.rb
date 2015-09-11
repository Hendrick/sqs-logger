$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require_relative '../lib/sqs_logger'
require 'minitest/autorun'
require 'fake_sqs/test_integration'
require 'ostruct'

def rack_get(path)
  app = proc {[200,{},['Hello, world.']]}
  stack = SqsLogger::Logger.new(app)
  request = Rack::MockRequest.new(stack)
  request.get(path)
end

def fake_sqs_client(queue_name)
  client = Aws::SQS::Client.new
  client.config.endpoint = $fake_sqs.uri
  client.create_queue({queue_name: queue_name})

  Aws::SQS::Client.stub(:new, client) do
    yield client
  end
end

def stub_and_verify_sqs_client
  client = MiniTest::Mock.new

  Aws::SQS::Client.stub(:new, client) do
    yield client
  end

  client.verify
end

def expect_queue_url(client, queue_name)
  client.expect(:get_queue_url,
                OpenStruct.new(queue_url: queue_name),
                [{queue_name: queue_name}])
end

def messages_in_queue(client, queue_name)
  client.receive_message({queue_url: client.get_queue_url({queue_name: queue_name}).queue_url}).messages
end

Aws.config.update(
  credentials: Aws::Credentials.new("fake", "fake"),
  region: "us-east-1"
)

$fake_sqs = FakeSQS::TestIntegration.new(
    database: ":memory:",
    sqs_endpoint: "localhost",
    sqs_port: 4568,
)
