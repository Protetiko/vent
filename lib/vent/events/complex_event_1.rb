# frozen_string_literal: true

# This Event have a predefined event_id/routing_key and implements message
# transformation. It expects to recieve a user hash as param from which it
# will extract :id and :name and construct the message that is published.
#
# usage:
#
#   Vent::Events::ComplexEvent1.publish user.to_hash
#
#
#

module Vent
  module Events
    class ComplexEvent1
      include Vent::Event

      event_id 'events.complex1.created'

      def message(params = {})
        {
          id:   params.dig(:user, :id),
          name: params.dig(:user, :name)
        }
      end
    end
  end
end
