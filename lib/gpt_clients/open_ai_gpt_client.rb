module Agents
  class OpenAiGptClient < GptClient
    attr_reader :open_ai_client
    attr_reader :default_params

    def initialize(open_ai_client:, default_params: {}, **args)
      super(**args)
      @open_ai_client = open_ai_client
      @default_params = {
        model: "gpt-3.5-turbo-1106",
        temperature: 0.7,
      }.merge(default_params)
    end

    def chat(prompt: "", **args)
      messages = []
      messages << { role: "system", content: "#{args[:system_prompt] || 'You are a helpful assistant.'}" }
      messages << { role: "user", content: "#{prompt}" }

      Agents.logger.debug("Sending to ChatGPT:")
      Agents.logger.debug(messages)

      parameters = default_params.merge({messages: messages})

      completions = open_ai_client.chat parameters: parameters

      Agents.logger.debug("ChatGPT Responded:")
      Agents.logger.debug(completions)

      text = completions.dig("choices", 0, "message", "content")

      Agents.logger.debug("-" * 80)
      Agents.logger.debug text
      Agents.logger.debug("-" * 80)

      GptResponse.new(text)
    end

  end
end