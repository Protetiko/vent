# frozen_string_literal: true

module Vent
  class HutchPublisher < Vent::Publisher
    def self.publish(routing_key, message)
      Hutch.publish(routing_key, message)
    end
  end
end
