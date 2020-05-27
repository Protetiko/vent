# frozen_string_literal: true

module Vent
  module WisperListener
    def register(event, method, async: true)
      Vent::WisperPublisher.subscribe(
        self.new,
        on:    event,
        with:  method,
        async: async
      )
    end
  end
end
