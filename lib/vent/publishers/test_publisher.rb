# frozen_string_literal: true

module Vent
  class TestPublisher < Vent::Publisher

    def self.queue
      @queue ||= {}
    end

    def self.publish(routing_key, message)
      queue[routing_key] ||= []
      queue[routing_key] << { :routing_key => routing_key, :message => message }
    end
  end
end
