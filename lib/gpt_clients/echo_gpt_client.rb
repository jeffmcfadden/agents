module Agents
  class EchoGptClient < GptClient

    # Returns the input prompt as the output.
    # @param [String] prompt
    # @return [GPTResponse] response The response will be the same as the prompt.
    def chat(prompt: "", **args)
      GptResponse.new(prompt.to_s)
    end
  end
end