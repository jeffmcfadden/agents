require 'agents'

module Agents
  class TestTodoGptAgent < TLDR

    def setup
      @agent = TodoGptAgent.new(gpt_client: EchoGptClient.new)

      add_todo_action = Action.new(name: "add_todo",
                                   description: "Add a todo to a list",
                                   arguments: [ActionArgument.new(name: "todo_list",  type: "String", description: "The name of the todo list to add the item to"),
                                               ActionArgument.new(name: "item_title", type: "String", description: "The title of the item to add to the list")],
                                   examples: [ActionExample.new(input: "I'm out of milk and bread",
                                                                output: { response: "I added milk and bread to your grocery list.",
                                                                          actions: [{name: "add_item", args:[{todo_list: "Grocery", "item_title": "milk"}]},
                                                                                    {name: "add_item", args:[{todo_list: "Grocery", "item_title": "bread"}]}
                                                                          ]}.to_json  )]
      ) do |**args|
        return "I added the todo"
      end

      @agent.register(action: add_todo_action)
    end

    def test_prompt
      expected_prompt = <<~EOS
You are a helpful assistant specializing in Todo List and Reminders Management. Please do your best to complete
any requests you are given. For each request, please respond ONLY with a JSON object. The JSON object should have
two top-level keys: `response` and `actions`. The `response` key should be a short string that summarizes the actions
to be taken. The `actions` key should be an array of JSON objects, each of which has a `name` key and an `args` key.
If you aren't sure what actions should be taken, or you don't think there's anything relevant, then respond with
an empty array for the `actions` key.


The following actions are supported: 
add_todo: Add a todo to a list
  Arguments:
    todo_list: The name of the todo list to add the item to
    item_title: The title of the item to add to the list
  For example:
    Input: I'm out of milk and bread
    Output: {"response":"I added milk and bread to your grocery list.","actions":[{"name":"add_item","args":[{"todo_list":"Grocery","item_title":"milk"}]},{"name":"add_item","args":[{"todo_list":"Grocery","item_title":"bread"}]}]}


EOS
      assert_equal(expected_prompt, @agent.system_prompt)
    end


  end
end