# frozen_string_literal: true

# The QueuedWisperPublisher is used for App internal event publishing with guaranteed delivery order. If the
# order of a `create` and `delete` event is important, use the queued version. The QueuedWisperPublisher is
# storing jobs in a queue, at the same time a thread is processing this queue in a FIFO fashion
#
# QueuedWisperListener listens to events from the QueuedWisperPublisher.
#
# Usage:
#
# class MyListener
#   extend Vent::QueuedWisperListener
#   register 'event.my.event', :handle
#
#   ... etc

require 'wisper'

module Vent
  class QueuedWisperPublisher < Vent::Publisher
    class << self
      include Wisper::Publisher

      #max_workers 4

      MessageStruct = Struct.new(:routing_key, :body, :message_id, :timestamp)

      def publish(routing_key, message)
        @worker ||= nil

        queue << MessageStruct.new(routing_key, message, 'notimplemented', Time.now)

        unless @worker
          @worker = Thread.new do
            while queue.size > 0
              msg = queue.pop
              broadcast(msg.routing_key, msg)
            end

            @worker = nil
            Thread.exit
          end
        end
      end

      def queue
        @queue ||= Queue.new
      end
    end
  end
end
