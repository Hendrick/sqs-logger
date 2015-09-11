require_relative "../minitest_helper.rb"

describe SqsLogger::SqsWriter do
  describe "#write" do
    it "sends the message to the sqs client" do
      queue_name = 'my queue'
      message_args = nil

      stub_and_verify_sqs_client do |client|
        expect_queue_url(client, queue_name)
        client.expect(:send_message, '') do |args|
          message_args = args.first
        end

        subject = SqsLogger::SqsWriter.new(queue_name)
        subject.write('my message')
      end

      assert_equal(message_args[:queue_url], queue_name)
      assert_equal(message_args[:message_body], 'my message')
    end
  end

  describe "#close" do
    it "must respond to close to conform to the IO interface" do
      subject = SqsLogger::SqsWriter.new('foo')
      assert subject.respond_to?(:close)
    end
  end
end
