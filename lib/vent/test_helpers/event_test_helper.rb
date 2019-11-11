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
      event = Vent::TestPublisher.queue[key].pop
      assert event
      assert_equal key, event[:routing_key]
      yield(event) if block_given?
    end
  end
end
