module SqsLogger
  class Logger < ::Rack::CommonLogger
    def initialize(app)
      @app = app
      @sqs_writer = SqsWriter.new(SqsLogger.config.sqs_queue_name)
    end

    private
    def log(env, status, header, began_at)
      now = Time.now
      message = {
        '@timestamp' => now.utc.iso8601,
        'method'   => env['REQUEST_METHOD'],
        'path'     => env['PATH_INFO'],
        'status'   => status.to_s[0..3],
        'duration' => now - began_at,
        'app' => SqsLogger.config.application_name
      }

      @sqs_writer.write(message.to_json)
    end
  end
end
