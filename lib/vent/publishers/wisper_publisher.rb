# frozen_string_literal: true

# The WisperPublisher is used for App internal event publishing. This can happen
# asynchroniously or synchroniously. To recieve events, `extend` the `WisperListener`
# and `register`.
#
# WisperListener listens to events from the WisperPublisher. Only one queue is
# supported, but listeners will only recieve registered events.
#
# Usage:
#
# class MyListener
#   extend Vent::WisperListener
#   register 'event.my.event', :handle
#
#   def handle(msg)
#     puts msg
#   end
# end
#
#
# class MyEvent < Events::SimpleEvent
#   event_id 'event.my.event'
#
#   configure do |config|
#     config.publishers << Vent::WisperPublisher
#   end
# end
#
# MyEvent.publish message: "This is Awesome!"
# => "This is Awesome!"

require 'wisper'
require 'sucker_punch'

module Wisper
  class SuckerPunchBroadcaster
    def broadcast(subscriber, _publisher, event, args)
      Wrapper.perform_async(subscriber, event, args)
    end

    class Wrapper
      include SuckerPunch::Job

      def perform(subscriber, event, args)
        subscriber.public_send(event, *args)
      end
    end

    def self.register
      Wisper.configure do |config|
        config.broadcaster :sucker_punch, SuckerPunchBroadcaster.new
        config.broadcaster :async,        SuckerPunchBroadcaster.new
      end
    end
  end
end

Wisper::SuckerPunchBroadcaster.register

module Vent
  class WisperPublisher < Vent::Publisher
    class << self
      include Wisper::Publisher

      MessageStruct = Struct.new(:routing_key, :body, :message_id, :timestamp)

      def publish(routing_key, message)
        msg = MessageStruct.new(routing_key, message, 'notimplemented', Time.now)
        broadcast(routing_key, msg)
      end
    end
  end
end
