module Agents
  class Agent
    attr_reader :gpt_client
    attr_reader :name
    attr_reader :description
    attr_reader :system_prompt
    attr_reader :actions
    attr_reader :children

    DEFAULT_SYSTEM_PROMPT = <<~EOS
        You are a helpful assistant. You will try your best to help answer or delegate each request you receive. If you need
        additional information to process a request, please ask for it. If you're not quite sure what to do, please ask for
        help or clarification.

        For each request, please respond ONLY with a JSON object. The JSON object should have a single (one) top-level key: `actions`. 
        The `actions` key should be an array of JSON objects, each of which has a `name` key and an `args` key. If you aren't sure what actions 
        should be taken, or you don't think there's anything relevant, then respond with an empty object for the `actions` key. The `args`
        key should be a JSON object with the arguments for the action.

EOS

    # @param actions [Array<Actions::Action>]
    def initialize(gpt_client:, name: "", description: "", system_prompt: DEFAULT_SYSTEM_PROMPT, actions: [Actions::AskForClarificationAction.new], children: [])
      @gpt_client = gpt_client
      @name = name
      @description = description
      @system_prompt = system_prompt
      @children = children

      @actions = actions
      @actions << Actions::DelegateAction.new(handler: self) if children.any?
    end

    def handle(request:)
      gpt_response = gpt_client.chat system_prompt: build_prompt, prompt: "#{request.request_text}"

      results = gpt_response.suggested_actions.map{ |sa|
        action = actions.find{ |a| a.name == sa.dig("name") }

        unless action.nil?
          return action.perform(request: request, args: sa.dig("args"))
        else
          return nil
        end
      }.compact

      if results.empty?
        "I'm sorry, I don't know how to handle that request."
      else
        results.reduce("", :+)
      end
    end

    def build_prompt
      prompt = system_prompt.dup

      if actions.any?
        prompt << "The actions you can take are:\n"
        prompt << actions.collect(&:for_prompt).join("\n\n")
      end

      if children.any?
        prompt << <<~EOS

If you don't know how to handle this request, please delegate it to another agent. The agents you can delegate to are:
#{children.each.collect{ "  - #{_1.name}: #{_1.description}" }.join("\n")}

If you choose to delegate this request, please be sure to include `agent` as a key in your `args` object.

EOS
      end

      prompt
    end

    def delegate_request(request:, args:)
      children.find{ |c| c.name == args.dig("agent") }&.handle(request: request)
    end

  end
end