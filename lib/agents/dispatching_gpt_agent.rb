module Agents
  class DispatchingGptAgent < Agent

    attr_reader :agents

    def initialize(agents:[], **args)
      super(**args)
      @agents = agents
    end

    def system_prompt
      prompt = <<~EOS
        You are a helpful assistant. You will try your best to help answer or delegate each request you receive. If you need
        additional information to process a request, please ask for it. If you're not quite sure what to do, please ask for
        help or clarification.

        For each request, please respond ONLY with a JSON object. The JSON object should have two top-level keys: `response` 
        and `actions`. The `response` key should be a short message that summarizes the actions to be taken. The `actions` key 
        should be an array of JSON objects, each of which has a `name` key and an `args` key. If you aren't sure what actions 
        should be taken, or you don't think there's anything relevant, then respond with an empty array for the `actions` key.

        The actions you can take are:

        `ask_for_clarification`: Ask for help or clarification. The `args` key should be a JSON object with a single key, `request_text`.
        `delegate`: Delegate the request to another assistant. The `args` key should be a JSON object with a single key, `next_agent`.

        The agents you can delegate to are:
            - #{agents.each.collect{ "    - #{_1.name}: #{_1.description}" }.join("\n")}

        If you are not sure which Assistant to use, it's okay to ask for more information with the `ask_for_clarification` action.
      
      EOS
    end

    def handle(request:)
      response = gpt_client.chat system_prompt: system_prompt, prompt: "#{prompt_prefix}#{request.request_text}"

      response.suggested_actions.each do |action|
        actions.find{ |a| a.name == action["name"] }&.call(action["args"])
      end

      response
    end

  end
end