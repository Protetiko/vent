# frozen_string_literal: true

# This example of a complex event only send events with id `events.complex.2` and it overrides
# the globally configured publishers to only the CommandLinePublisher
#
# usage:
#   Vent::Events::ComplexEvent2.publish user.to_hash

module Vent
  module Events
    class ComplexEvent2
      include Vent::Event
      event_id 'events.complex.2'

      configure do |config|
        config.publishers = [Vent::CommandLinePublisher]
      end

      def message(params = {})
        {
          user_id: params[:user][:id],
          user_name: params[:user][:name]
        }
      end
    end
  end
end
