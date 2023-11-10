module Agents
  class InformationRetrievalGptAgent < GptAgent

    attr_reader :system_prompt
    def initialize(**args)
      super(**args)
      @description = "I am an AI Assistant that specializes in fetching information and answering general questions, etc."
      @system_prompt = <<~EOS
        You are a helpful assistant.
      EOS
    end

    def handle(request:)
      gpt_client.chat system_prompt: system_prompt, prompt: request.request_text
    end
  end
end