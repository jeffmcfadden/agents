module Agents
  class CategorizingGptAgent < Agent

    attr_reader :system_prompt
    def initialize(**args)
      super(**args)
      @system_prompt = <<~EOS
        You are a helpful assistant specializing in categorization. For each request to follow,
        please respond with a JSON object with a single key, 'category'. Each request will include
        the valid values for the category key.
      EOS
    end

    # @return [GPTResponse] response
    def handle(request:)
      gpt_client.chat system_prompt: system_prompt, prompt: request.request_text
    end
  end
end