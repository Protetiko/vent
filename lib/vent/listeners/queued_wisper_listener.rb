# frozen_string_literal: true

module Vent
  module QueuedWisperListener
    def register(event, method, **_params)
      Vent::QueuedWisperPublisher.subscribe(
        self.new,
        on:    event,
        with:  method,
        async: false
      )
    end
  end
end
