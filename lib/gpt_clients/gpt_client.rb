# frozen_string_literal: true

module Agents
  class GptClient
    def initialize()
    end

    # Chats via the GPT Client, returns a GPTResponse
    # @return [GPTResponse] response
    def chat(prompt: "", **args)
      GptResponse.new("Error: No GPT Client Setup.")
    end
  end
end