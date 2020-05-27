require 'test_helper'

class EventMixinTest < MiniTest::Test

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

  def test_vent_mixin
    Vent.configure do |config|
      config.publishers = all_publishers
    end

    self.class.const_set(:TestEvent1, Class.new {
        include Vent::Event
      }
    )
    assert_equal all_publishers.size, TestEvent1.configuration.publishers.size

    self.class.const_set(:TestEvent2, Class.new {
        include Vent::Event

        configure do |config|
          config.publishers = TWO_PUBLISHERS
        end
      }
    )
    assert_equal TWO_PUBLISHERS.size, TestEvent2.configuration.publishers.size
  end
end
