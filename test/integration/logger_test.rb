require_relative "../minitest_helper.rb"

describe SqsLogger::Logger do
  before do
    $fake_sqs.start

    @queue_name = "my_queue"
    @app_name = "my app name"

    SqsLogger.setup do |config|
      config.sqs_queue_name = @queue_name
      config.application_name = @app_name
    end
  end

  after do
    $fake_sqs.stop
  end

  describe "writes logs to the configured sqs queue" do
    it "writes out the configured sqs queue name" do
      fake_sqs_client(@queue_name) do |client|
        assert_equal 0, messages_in_queue(client, @queue_name).count
        rack_get("/")
        assert_equal 1, messages_in_queue(client, @queue_name).count
      end
    end

    it "logs the request information in the log message body" do
      fake_sqs_client(@queue_name) do |client|
        rack_get("/")

        log_body = messages_in_queue(client, @queue_name).first.body
        log = JSON.parse(log_body)

        assert_equal("GET", log['method'])
        assert_equal("200", log['status'])
        assert_equal("/", log['path'])
        assert_equal(@app_name, log['application_name'])
      end
    end
  end
end
