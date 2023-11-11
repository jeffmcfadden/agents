# frozen_string_literal: true

module Agents
  # An agent that echoes back the request text. Useful for testing.
  class EchoGptAgent < Agent

    # @param [Request] request
    def handle(request:)
      GptResponse.new(request.request_text)
    end
  end
end