class QueuedWisperPublisherTest < MiniTest::Test

  class CounterEvent
    include Vent::Event

    event_id 'counter'

    configure do |config|
      config.publishers = []
      config.publishers << Vent::QueuedWisperPublisher
    end

    def message(count:)
      { count: count }
    end
  end

  class CounterEventListener
    extend Vent::QueuedWisperListener
    register 'counter', :handle

    def self.events
      @@events
    end

    def handle(message)
      @@events ||= []
      @@events << message.body[:count]
    end
  end

  def test_correctness_of_publishing_order
    1000.times do |i|
      CounterEvent.publish(count: i+1)
    end
    sleep(0.5)
    assert_equal Array(1..1000), CounterEventListener.events
  end
end
