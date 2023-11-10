module Agents
  # An agent that does not add a prompt to the request, but simply passes it through.
  # Use if your test _is _the prompt, for example.
  class PromptlessGptAgent < GptAgent
    def handle(request:)
      Response.new(response_text: gpt_client.chat(prompt: request.request_text))
    end

  end
end