# frozen_string_literal: true

module Agents
    # An agent that echoes back the request text. Useful for testing.
    class EchoAgent < Agent

      # @param [Request] request
      def handle(request:)
        Response.new(request.request_text)
      end
    end
end