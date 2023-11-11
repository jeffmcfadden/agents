# frozen_string_literal: true

# This actually tests the full Open AI call path. It can be slow, and tldr will
# fail after 1.8 seconds, so you need to run this separately.

# Run this file with:
# OPENAI_ACCESS_TOKEN="sk-123YourToken" bundle exec ruby test/test_openai.rb
require 'openai'
require 'agents'

module Agents

  class AddTodoAction < Action
    def initialize
      super(name: "add_todo",
            description: "Add a todo to a list",
            arguments: [ActionArgument.new(name: "todo_list",  type: "String", description: "The name of the todo list to add the item to"),
                        ActionArgument.new(name: "item_title", type: "String", description: "The title of the item to add to the list")]
      )

    end
    def perform(request:, args:)
      puts "I am the add todo action and I just handled #{args}"
    end
  end

  class TestOpenAi
    def initialize
      @openai_client = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
      @gpt_client = Agents::OpenAiGptClient.new(open_ai_client: @openai_client)

      @todo_agent = Agent.new(gpt_client: @gpt_client,
                              name: "todo_agent",
                              description: "Handles todo list and reminders actions.",
                              actions: [AddTodoAction.new]
      )

      @primary_agent = Agent.new(gpt_client: @gpt_client, children: [@todo_agent])
    end


    def test_todo_action
      response = @primary_agent.handle(request: Request.new("I need to buy bread and milk"))
      puts response
    end

  end
end

# Skip this test if we don't have an access token
unless ENV['OPENAI_ACCESS_TOKEN'].nil?
  Agents::TestOpenAi.new.test_todo_action
end
