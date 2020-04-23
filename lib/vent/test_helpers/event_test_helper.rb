# frozen_string_literal: true

# Events::SimpleEvent.configure do |config|
#   config.publishers = [Vent::TestPublisher]
# end
#
# class MyTest < MiniTest::Test
#   def test_event
#     Events::SimpleEvent.publish routing_key: 'event.name'
#     assert_event('event.name') do |event|
#       # test event data here
#     end
#   end
# end
#

module TestHelpers
  module EventTestHelper
    def assert_event(key, &block)
      key = key.routing_key if !key.is_a?(String) && key.include?(Vent::Event)

      event = Vent::TestPublisher.queue[key]&.pop
      refute nil == event, "Expected the event `#{key}` to have been published"
      assert_equal key, event[:routing_key]
      yield(event, event[:message]) if block_given?
    end
  end
end
