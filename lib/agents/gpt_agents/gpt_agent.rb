module Agents
  class GptAgent < Agent
    attr_reader :gpt_client
    attr_reader :description
    attr_reader :system_prompt

    def initialize(gpt_client:, description: "An AI Chatbot", system_prompt: "", **args)
      super(**args)
      @gpt_client = gpt_client
      @description = description
      @system_prompt = system_prompt
    end

    def handle(request:)
      response = gpt_client.chat system_prompt: system_prompt, prompt: request.request_text

      response.suggested_actions.each do |action|
        actions.find{ |a| a.name == action["name"] }&.call(**action["args"])
      end

      Response.new(response.response_text)
    end

  end
end