require 'test_helper'

class EventConfigurationTest < MiniTest::Test

  let(:all_publishers) {
    [
      Vent::CommandLinePublisher,
      Vent::HutchPublisher,
      Vent::WisperPublisher,
    ]
  }

  ONE_PUBLISHER = [
    Vent::CommandLinePublisher,
  ]

  TWO_PUBLISHERS = [
    Vent::HutchPublisher,
    Vent::WisperPublisher,
  ]

  THREE_PUBLISHERS = [
    Vent::WisperPublisher,
    Vent::HutchPublisher,
    Vent::CommandLinePublisher,
  ]

  def test_vent_configuration
    Vent.configure do |config|
      config.publishers = all_publishers
    end

    assert_equal all_publishers.size, Vent.configuration.publishers.size
  end

  def test_event_configuration
    self.class.const_set(:TestEvent1, Class.new {
        include Vent::Event

        configure do |config|
          config.publishers = TWO_PUBLISHERS
        end
      }
    )
    assert_equal TWO_PUBLISHERS.size, TestEvent1.configuration.publishers.size
  end

  def test_without_configuration
    Vent.configure do |config|
      config.publishers = []
    end

    self.class.const_set(:TestEvent2, Class.new {
        include Vent::Event
      }
    )

    assert_equal 0, TestEvent2.configuration.publishers.size

    Vent.configure do |config|
      config.publishers = all_publishers
    end
    self.class.const_set(:TestEvent3, Class.new {
        include Vent::Event
      }
    )

    assert_equal all_publishers.size, TestEvent3.configuration.publishers.size
  end

  def test_combination_of_configurations
    Vent.configure do |config|
      config.publishers = all_publishers
    end

    self.class.const_set(:Event1, Class.new {
        include Vent::Event

        configure do |config|
          config.publishers = ONE_PUBLISHER
        end
      }
    )

    self.class.const_set(:Event2, Class.new {
        include Vent::Event

        configure do |config|
          config.publishers = TWO_PUBLISHERS
        end
      }
    )

    self.class.const_set(:Event3, Class.new {
        include Vent::Event

        configure do |config|
          config.publishers = THREE_PUBLISHERS
        end
      }
    )

    assert_equal all_publishers.size, Vent.configuration.publishers.size
    all_publishers.each_with_index do |p, i|
      assert_equal p, Vent.configuration.publishers[i]
    end

    assert_equal ONE_PUBLISHER.size, Event1.configuration.publishers.size
    ONE_PUBLISHER.each_with_index do |p, i|
      assert_equal p, Event1.configuration.publishers[i]
    end

    assert_equal TWO_PUBLISHERS.size, Event2.configuration.publishers.size
    TWO_PUBLISHERS.each_with_index do |p, i|
      assert_equal p, Event2.configuration.publishers[i]
    end

    assert_equal THREE_PUBLISHERS.size, Event3.configuration.publishers.size
    THREE_PUBLISHERS.each_with_index do |p, i|
      assert_equal p, Event3.configuration.publishers[i]
    end
  end
end
