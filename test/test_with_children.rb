require 'agents'

module Agents
  class TestWithChildren < TLDR

    class AddTodoAction < Action
      def initialize
        super(name: "add_todo",
              description: "Add a todo to a list",
              arguments: [ActionArgument.new(name: "todo_list",  type: "String", description: "The name of the todo list to add the item to"),
                          ActionArgument.new(name: "item_title", type: "String", description: "The title of the item to add to the list")]
              )

      end
      def perform(request:, args:)
        "I am the add todo action and I just handled a request"
      end
    end

    def setup
      @test_gpt_client = Agents::EchoGptClient.new

      @todo_agent = Agent.new(gpt_client: @test_gpt_client,
                              name: "todo_agent",
                              description: "Handles todo list and reminders actions.",
                              actions: [AddTodoAction.new]
      )

      @primary_agent = Agent.new(gpt_client: @test_gpt_client, children: [@todo_agent])
    end

    def test_prompt
      expected_prompt = <<~EOS
You are a helpful assistant. You will try your best to help answer or delegate each request you receive. If you need
additional information to process a request, please ask for it. If you're not quite sure what to do, please ask for
help or clarification.

For each request, please respond ONLY with a JSON object. The JSON object should have a single (one) top-level key: `actions`. 
The `actions` key should be an array of JSON objects, each of which has a `name` key and an `args` key. If you aren't sure what actions 
should be taken, or you don't think there's anything relevant, then respond with an empty object for the `actions` key. The `args`
key should be a JSON object with the arguments for the action.

The ONLY actions you can take are: ask_for_clarification, delegate. Here are the details on those actions: 
ask_for_clarification: Ask for clarification if the request is not clear, or you don't know how to help.
  Arguments:
    question: The question, clarification, or additional information you need.


delegate: Delegate to another agent
  Arguments:
    agent: The name of the agent to delegate the request to.

If you don't know how to handle this request, please `delegate` it to another agent. The agents you can `delegate` to are:
  - todo_agent: Handles todo list and reminders actions.

If you choose to delegate this request, please be sure to include `agent` as a key in your `args` object.

      EOS

      assert_equal expected_prompt, @primary_agent.build_prompt
    end

    def test_delegating
      echo_request_data = { actions: [{ name: "delegate", args: { agent: "todo_agent" } }] }

      response = @primary_agent.handle(request: Request.new(echo_request_data.to_json))

      # We expect this response because the default agent won't know what to do with the request, but it won't have
      # broken anything either.
      assert_equal "I'm sorry, I don't know how to handle that request.", response
    end

  end
end

