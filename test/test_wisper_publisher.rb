require 'test_helper'

class WisperPublisherTest < MiniTest::Test

  class TestEvent
    include Vent::Event

    configure do |config|
      config.publishers = []
      config.publishers << Vent::WisperPublisher
      # puts config.publishers
    end

    def self.inherited(base)
      base.configuration = self.configuration
      # - or-
      # base.configure do |config|
      #   config.publishers = []
      #   config.publishers << Vent::WisperPublisher
      #   puts  config.publishers
      # end
    end
  end

  class CreateEvent < TestEvent; event_id 'created'; end
  class UpdateEvent < TestEvent; event_id 'updated'; end
  class DeleteEvent < TestEvent; event_id 'deleted'; end

  class TestListener
    extend Vent::WisperListener
    def self.events
      @@events ||= []
    end

    def handle(message)
      @@events ||= []
      @@events << message.routing_key
    end
  end

  class CreateListener < TestListener
    register 'created', :handle, async: false
  end

  class UpdateListener < TestListener
    register 'updated', :handle, async: false
  end

  class DeleteListener < TestListener
    register 'deleted', :handle, async: false
  end

  def test_wisper_event_publishing
    CreateEvent.publish
    assert_equal 'created', TestListener.events.last
    UpdateEvent.publish
    assert_equal 'updated', TestListener.events.last
    UpdateEvent.publish
    assert_equal 'updated', TestListener.events.last
    DeleteEvent.publish
    assert_equal 'deleted', TestListener.events.last

    assert_equal 4, TestListener.events.size
  end
end
