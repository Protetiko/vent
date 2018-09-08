# frozen_string_literal: true

module Vent
  class CommandLinePublisher < Vent::Publisher
    def self.publish(routing_key, message)
      puts "**** #{routing_key} : #{message}"
    end
  end
end
