module SqsLogger
  class SqsWriter
    def initialize(queue_name)
      @queue_name = queue_name
      @client = Aws::SQS::Client.new
    end

    def write(message)
      @client.send_message({
        queue_url: queue_url,
        message_body: message,
      })
    end

    def close(*args);end

    private
    def queue_url
      @queue_url ||= @client.get_queue_url({queue_name: @queue_name}).queue_url
    end
  end
end
