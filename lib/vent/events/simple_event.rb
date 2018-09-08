# frozen_string_literal: true

# The SimpleEvent does not specify a routing key or a message. This means that
# the calling method must know and implement these things. It will work ok in
# the simple case when no or little data transformation is needed, and where the
# event is ever only used in one place. If it is used in multiple places, usage
# of SimpleEvent is adviced.
#
# usage:
#
#   Vent::Events::SimpleEvent.perform(
#     routing_key: 'events.update.user',
#     message: user.to_hash
#   )

module Vent
  module Events
    class SimpleEvent
      include Vent::Event
    end
  end
end

