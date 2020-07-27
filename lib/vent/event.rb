# frozen_string_literal: true

require_relative 'configuration'

module Vent
  module Event
    def self.included(base)
      base.extend(ClassMethods)
      base.configure
    end

    def routing_key
      self.class.routing_key
    end

    def message(params = {})
      # Default to not transform the data
      params
    end

    module ClassMethods
      attr_accessor :routing_key
      attr_accessor :configuration

      def configure
        self.configuration ||= Vent.configuration.clone
        yield(self.configuration) if block_given?
      end

      def event_id(event)
        self.routing_key = event
      end

      def publish(params = {})
        key     = params.delete(:routing_key) || nil
        message = params.delete(:message)

        event   = new
        key     = key || event.routing_key
        message = event.message(**params)  unless message

        configuration.publishers.each do |publisher|
          publisher.publish(key, message)
        end
      end
    end
  end
end
