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

module Vent
  class WisperPublisher < Vent::Publisher
    include SuckerPunch::Job
    include Wisper::Publisher

    MessageStruct = Struct.new(:routing_key, :body, :message_id, :timestamp)

    def self.publish(_routing_key, _message)
      WisperPublisher.new.publish(key: _routing_key, message: _message)
    end

    def publish(key: nil, message: nil, **event)
      msg = MessageStruct.new(key, message, 'notimplemented', Time.now)
      broadcast(key, msg)
    end
  end
end

module Vent
  module WisperListener
    def register(event, method)
      Vent::WisperPublisher.subscribe(
        self.new,
        on:   event,
        with: method
      )
    end
  end
end
