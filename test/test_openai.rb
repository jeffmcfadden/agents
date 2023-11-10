# frozen_string_literal: true

# This actually tests the full Open AI call path. It can be slow, and tldr will
# fail after 1.8 seconds, so you need to run this separately.

# Run this file with:
# OPENAI_ACCESS_TOKEN="sk-123YourToken" bundle exec ruby test/test_openai.rb
require 'openai'
require 'agents'

module Agents

  class ActionPerformingGptAgent < GptAgent
  end

  class TestOpenAi
    def initialize
      @openai_client = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_TOKEN'])
      @gpt_client = Agents::OpenAiGptClient.new(open_ai_client: @openai_client)
    end

    def test_basic_chat
      puts "-" * 60
      puts "test_basic_chat:"
      @agent = Agents::PromptlessGptAgent.new(gpt_client: @gpt_client)
      response = @agent.handle(request: Request.new("Tell me a joke"))
      puts response.response_text
    end

    def test_dispatching_chat
      puts "-" * 60
      puts "test_dispatching_chat:"
      dispatcher = Agents::DispatchingGptAgent.new(gpt_client: @gpt_client)
      dispatcher.register(Agents::TodoGptAgent.new(gpt_client: @gpt_client))
      dispatcher.register(Agents::CalendarGptAgent.new(gpt_client: @gpt_client))
      dispatcher.register(Agents::InformationRetrievalGptAgent.new(gpt_client: @gpt_client))

      response = dispatcher.handle(request: Request.new("I need to buy break and milk"))
      puts response
    end

    def test_todo_action
      puts "-" * 60
      puts "test_dispatching_chat:"

      todo_agent = Agents::TodoGptAgent.new(gpt_client: @gpt_client)

      add_todo_action = Action.new(name: "add_todo",
                                   description: "Add a todo to a list",
                                   arguments: [{name: "todo_list",  description: "The name of the todo list to add the item to"},
                                               {name: "item_title", description: "The title of the item to add to the list"}]
      ) do |**args|
        puts "I added the todo"
      end

      todo_agent.register(action: add_todo_action)

      dispatcher = Agents::DispatchingGptAgent.new(gpt_client: @gpt_client)
      dispatcher.register(todo_agent)

      response = dispatcher.handle(request: Request.new("I need to buy break and milk"))
      puts response.response_text
    end

  end
end

# Skip this test if we don't have an access token
unless ENV['OPENAI_ACCESS_TOKEN'].nil?
  # Agents::TestOpenAi.new.test_basic_chat
  # Agents::TestOpenAi.new.test_dispatching_chat
  Agents::TestOpenAi.new.test_todo_action
end
