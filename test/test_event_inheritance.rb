require 'test_helper'

class EventInheritanceTest < MiniTest::Test

  let(:all_publishers) {
    [
      Vent::CommandLinePublisher,
      Vent::HutchPublisher,
      Vent::WisperPublisher,
    ]
  }

  TWO_PUBLISHERS = [
    Vent::HutchPublisher,
    Vent::WisperPublisher,
  ]

  def test_event_inheritance
    Vent.configure do |config|
      config.publishers = all_publishers
    end

    self.class.const_set :TestEvent1, Class.new(Vent::Events::SimpleEvent)
    assert_equal all_publishers.size, TestEvent1.configuration.publishers.size

    self.class.const_set :TestEvent2, Class.new(Vent::Events::SimpleEvent) {
      configure do |config|
        config.publishers = TWO_PUBLISHERS
      end
    }
    assert_equal TWO_PUBLISHERS.size, TestEvent2.configuration.publishers.size
  end
end
