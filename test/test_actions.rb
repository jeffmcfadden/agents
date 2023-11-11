require 'agents'

module Agents
  class TestActions < TLDR

    class AddTodoAction < Action
      def initialize
        super(name: "add_todo",
              description: "Add a todo to a list",
              arguments: [ActionArgument.new(name: "todo_list",  type: "String", description: "The name of the todo list to add the item to"),
                          ActionArgument.new(name: "item_title", type: "String", description: "The title of the item to add to the list")]
        )

      end
      def perform(request:, args:)
        "I am the add todo action and I just handled a request."
      end
    end

    def setup
      @test_gpt_client = Agents::EchoGptClient.new

      @todo_agent = Agent.new(gpt_client: @test_gpt_client,
                              name: "todo_agent",
                              description: "Handles todo list and reminders actions.",
                              actions: [AddTodoAction.new]
      )
    end

    def test_action
      echo_request_data = { actions: [{ name: "add_todo", args: { todo_list: "Grocery", item_title: "Milk" } }] }

      response = @todo_agent.handle(request: Request.new(echo_request_data.to_json))

      # We expect this response because the default agent won't know what to do with the request, but it won't have
      # broken anything either.
      assert_equal "I am the add todo action and I just handled a request.", response
    end

  end
end

