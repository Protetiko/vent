require_relative 'vent/version'
require_relative 'vent/configuration'
require_relative 'vent/event'
require_relative 'vent/publisher'
require_relative 'vent/publishers/command_line_publisher'
require_relative 'vent/publishers/hutch_publisher'
require_relative 'vent/publishers/test_publisher'
require_relative 'vent/publishers/wisper_publisher'
require_relative 'vent/publishers/queued_wisper_publisher'
require_relative 'vent/publishers/log_publisher'
require_relative 'vent/publishers/null_publisher'
require_relative 'vent/listeners/wisper_listener'
require_relative 'vent/listeners/queued_wisper_listener'

module Vent
  class << self
    attr_accessor :_configuration

    def configure
      yield(configuration) if block_given?
    end

    def configuration
      self._configuration ||= Vent::Configuration.new
    end
  end
end

require_relative 'vent/events/simple_event'
