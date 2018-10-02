# frozen_string_literal: true

require_relative 'publishers/null_publisher'

module Vent
  class Configuration
    attr_accessor :publishers
    attr_accessor :async
    attr_accessor :async_adapter

    def initialize
      @publishers = [ Vent::NullPublisher ]
      @async = false
      #@async_adapter = Vent::Async::SuckerPunch
    end
  end
end
