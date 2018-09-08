require_relative 'vent/version'
require_relative 'vent/configuration'
require_relative 'vent/event'
require_relative 'vent/publisher'
require_relative 'vent/publishers/command_line_publisher'
require_relative 'vent/publishers/hutch_publisher'
require_relative 'vent/publishers/test_publisher'
require_relative 'vent/publishers/wisper_publisher'
require_relative 'vent/publishers/log_publisher'
require_relative 'vent/publishers/null_publisher'

module Vent
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Vent::Configuration.new
    yield(configuration) if block_given?
  end
end
