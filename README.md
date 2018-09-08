# Vent - the adaptabel publishing library

Vent makes it dead simple to handle event publishing throughout your application. Vent use a adapter pattern to make it easily extendable with new publisher. The main concern of Vent is to connect event publishing with publisher adapters. Any transportation method is supported (given a publisher adapter is available), for example publishing to RabbitMQ, Log files and STDOUT. Multiple publishers are supported for events, so a message could be published from one place both to RabbitMQ, internally inside the application and the log file at the same time. Horray!

## Todo

-[ ] Custom message validation
-[ ] Async publishing

## Setup

```ruby
gem 'vent'
```

```ruby
# config/initializers/vent.rb (or whatever)

# Configure Vent to:
# 1. Publish to command line, RabbitMQ and Wisper in `development`
# 2. Publish to RabbitMQ and Wisper in `production`

Vent.configure do |config|
  config.publishers = []
    config.publishers << Vent::CommandLinePublisher if ENV['RACK_ENV'] == 'development'
    config.publishers << Vent::HutchPublisher if ENV['RACK_ENV'] == 'production' || ENV['RACK_ENV'] == 'development'
    config.publishers << Vent::WisperPublisher
end

```

## Usage

### The SimpleEvent

`Vent::Events::SimpleEvent` would be your go-to event for 99% of the cases.

```ruby
Vent::Events::SimpleEvent.publish routing_key: 'events.user.registered', message: user.to_h

# or create your very own simple event class by including Vent::Event

class MySimpleEvent
  include Vent::Event
end

MySimpleEvent.publish routing_key: 'events.user.registered', message: user.to_h
```

### Customizing events

It is possible to configure an event class with predefined routing key and message transformation

```ruby
# Predefine the routing key for this event
class UserRegisteredEvent
  include Vent::Event
  routing_key 'events.user.registered'
end

UserRegisteredEvent.publish message: user.to_h

# With message transformation
class UserRegisteredEvent < Vent::Events:SimpleEvent # can also inherit from SimpleEvent
  routing_key 'events.user.registered'

  # The `message` method will be called if a message is not defined in the `publish` call
  def message(params = {})
    # As an example, we might want to extract `:id` and `:name` from the user object
    # before we publish the message.
    msg = {
      id:   params[:id],
      name: params[:name]
    }
    return msg
  end
end

UserRegisteredEvent.publish user.to_h
```

### Overriding configuration in event classes

It is possible to have different configuration in event classes:

```ruby
# Given this Vent configuration...
Vent.configure do |config|
  config.publishers = []
    config.publishers << Vent::CommandLinePublisher if ENV['RACK_ENV'] == 'development'
    config.publishers << Vent::HutchPublisher if ENV['RACK_ENV'] == 'production' || ENV['RACK_ENV'] == 'development'
    config.publishers << Vent::WisperPublisher
end

# ... this class will still only publish to the command line
class UserRegistrationEvent
  include Vent::Event
  event_id 'events.user.registered'

  configure do |config|
    config.publishers = [Vent::CommandLinePublisher]
  end
end

UserRegisteredEvent.publish message: "This message only prints to stdout"
=> "This message only prints to stdout"
```

### Creating Publisher adapters
A publisher adapter only need to inherit from `Vent::Publisher` and implement `self.publish(routing_key, message)`. Thats all!

Lets take a look at CommandLinePublisher:

```ruby
module Vent
  class CommandLinePublisher < Vent::Publisher
    def self.publish(routing_key, message)
      puts "**** #{routing_key} : #{message}"
    end
  end
end
```
 
Now lets implement a new RedisPublisher that will store the `routing_key` and `message` in redis:

```ruby
require "redis"

class RedisPublisher < Vent::Publisher
  def self.redis
	@redis ||= Redis.new #or put your redis config where ever
  end

  def self.publish(routing_key, message)
	# for whatever reason, store some data into redis:

	# If the message object has an ID, use it as key and store the rest of the message
	id = message.delete(:id)
    redis.set(id, message) if id
  end
end

class UserRegistrationEvent
  include Vent::Event
  event_id 'events.user.registered'

  configure do |config|
	# Also store the user in redis for whatever reason...
    config.publishers << [Vent::CommandLinePublisher]
  end
end

UserRegisteredEvent.publish message: user.to_h

redis = Redis.new
redis.get(user[:id])
```

### Asynchronoues event publishing

```ruby
configure do |config|
  config.async = true
  config.async_adapter = Vent::Async::SuckerPunch
end
```

Can also be configured for each Event class, to allow some events to publish async and others not.

## Publishers

- Null
- Command line
- Log
- Hutch (RabbitMQ)
- Wisper
- Test

### Null publisher

Just drops the message and does nothing.

```ruby
config.publishers << Vent::CommandLinePublisher
```

### Command line publisher

Prints the message to stdout.

```ruby
config.publishers << Vent::CommandLinePublisher
```

### Log publisher

Prints the message to whatever logger is defined. Normally you only want to use this 

```ruby
config.publishers << Vent::LogPublisher
```

### Hutch publisher

Publishes the message on RabbitMQ, using Hutch as a proxy. Configure RabbitMQ connection with the hutch config file.

```ruby
config.publishers << Vent::HutchPublisher
```

### Wisper publisher

The WisperPublisher is used for App internal event publishing. This can happen asynchroniously or synchroniously. To recieve events, `extend` the `WisperListener` and `register`.

WisperListener listens to events from the WisperPublisher. Only one queue is supported, but listeners will only recieve registered events.

```ruby
class MyEvent < Events::SimpleEvent
  event_id 'event.my.event'

  configure do |config|
    config.publishers << Vent::WisperPublisher
  end
end

class MyListener
  extend Vent::WisperListener
  register 'event.my.event', :handle

  def handle(message)
    # handle the message here
    puts message
  end
end

MyEvent.perform message: "This is Awesome!"
# => "This is Awesome!"
```
