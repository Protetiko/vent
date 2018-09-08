# frozen_string_literal: true

module Vent
  class LogfilePublisher < Vent::Publisher
    def self.publish(_routing_key, _message)
      logger.info '...'
    end
  end
end
