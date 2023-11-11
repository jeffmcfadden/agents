module Agents
  class DispatchingGptAgent < Dispatcher
    attr_reader :gpt_client

    def initialize(gpt_client:, **args)
      super(**args)
      @gpt_client = gpt_client
    end
    def agent_for_request(request:)
      categorize_request = Request.new(prompt_for_categorizing_request(request: request))

      response_data = CategorizingGptAgent.new(gpt_client: gpt_client)
                                          .handle(request: categorize_request).data

      agent_class = response_data["category"]
      agents.find{ _1.class.name == agent_class } || UnhandleableRequestAgent.new
    end

    def prompt_for_categorizing_request(request:)
      prompt = "The following is a list of Assistants and a description of what each can do: \n\n"
      prompt << agents.collect{ "#{_1.class.name}: #{_1.description}" }.join("\n\n")
      prompt << "If you are not sure which Assistant to use, it's okay to ask for more information.\n\n"
      prompt << "Please categorize the request by typing the name of the Assistant that best fits the request.\n\n"
      prompt << "Request: #{request.request_text}"
    end
  end
end