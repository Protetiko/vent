# frozen_string_literal: true

module Vent
  class NullPublisher
    def self.method_missing(method, *args, &block)

    end
  end
end
