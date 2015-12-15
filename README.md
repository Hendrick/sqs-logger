# SqsLogger

SqsLogger is a Ruby gem built to send log entries to sqs

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sqs_logger'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sqs_logger

## Usage

### Rails example

Add an initializer to configure SqsLogger:

```
SqsLogger.setup do |config|
  config.application_name = 'foobar'
  config.sqs_queue_name   = ENV['AWS_LOG_QUEUE']
end
```

In the appropriate environment file, add SqsLogger as middleware:

```
FooBar::Application.configure do
  config.middleware.use(SqsLogger::Logger)
end
```

### Sinatra example

Add an initializer to configure SqsLogger:

```
SqsLogger.setup do |config|
  config.application_name = 'foobar'
  config.sqs_queue_name   = ENV['AWS_LOG_QUEUE']
end
```

Add the SqsLogger middleware:

```
class Base < Sinatra::Base
  configure :production do
    use SqsLogger::Logger
  end
end
```
