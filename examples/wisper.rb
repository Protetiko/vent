# frozen_string_literal: true

require 'colorize'
require 'vent'
require 'securerandom'

Vent.configure do |config|
  config.publishers = []
  # config.publishers << Vent::WisperPublisher
  config.publishers << Vent::QueuedWisperPublisher
  config.publishers << Vent::CommandLinePublisher
end

class SimpleEvent
  include Vent::Event

  def self.inherited(base)
    base.configure
  end
end

User = Struct.new(:id, :name, :email, :role, keyword_init: true)

class UserCreatedListener
  extend Vent::QueuedWisperListener
  register 'events.user.created', :handle

  def handle(message)
    puts "#### #{message.routing_key} : #{message.body}".yellow
  end
end

class UserUpdatedListener
  extend Vent::QueuedWisperListener
  register 'events.user.updated', :handle

  def handle(message)
    puts "#### #{message.routing_key} : #{message.body}".yellow
  end
end


class UserDeletedListener
  extend Vent::QueuedWisperListener
  register 'events.user.deleted', :handle

  def handle(message)
    puts "#### #{message.routing_key} : #{message.body}".yellow
  end
end

class DeletedUserReferencesHandler
  extend Vent::QueuedWisperListener
  register 'events.user.deleted', :handle

  def handle(message)
    puts "==== #{message.routing_key} : #{message.body}".magenta
  end
end

class UserCreatedEvent < SimpleEvent
  event_id 'events.user.created'

  def message(user:)
    {
      user_id: user.id,
      user_name: user.name,
    }
  end
end


class UserUpdatedEvent < SimpleEvent
  event_id 'events.user.updated'

  def message(user:)
    user.to_h
  end
end

class UserDeletedEvent < SimpleEvent
  event_id 'events.user.deleted'

  def message(user:)
    {
      user_id: user.id
    }
  end
end


user = User.new(id: SecureRandom.uuid, name: 'Don', role: 'admin', email: 'don@ello.com')

UserCreatedEvent.publish(
  user: user
)

# BusinessLogic
user.name = "Don Atello"

UserUpdatedEvent.publish(
  user: user
)

# BusinessLogic
sleep(3)
user.role = "super_admin"

UserUpdatedEvent.publish(
  user: user
)

# BusinessLogic

UserDeletedEvent.publish(
  user: user
)


sleep(4)

class CounterEvent < SimpleEvent
  event_id 'counter'

  def message(count:)
    { count: count }
  end
end

class CounterEventListener
  extend Vent::QueuedWisperListener
  register 'counter', :handle

  def handle(message)
    puts "Processing #{message.body[:count]}".red
  end
end

class Counter2EventListener
  extend Vent::QueuedWisperListener
  register 'counter', :handle

  def handle(message)
    puts "Another processing #{message.body[:count]}".red
  end
end

t = Thread.new do
  1000.times do |i|
    CounterEvent.publish(count: i+1)
  end
  sleep(2)
  1000.times do |i|
    CounterEvent.publish(count: i+1001)
    sleep(0.001)
  end
end
t.join

sleep(5)
