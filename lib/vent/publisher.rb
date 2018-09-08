# frozen_string_literal: true

module Vent
  class Publisher
    def self.publish(_routing_key, _message)
      raise NotImplementedError
    end
  end
end
