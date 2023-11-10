require 'agents'

module Agents
  class TestGptDispatcher < TLDR

    def setup
      @gpt_client = EchoGptClient.new
      @dispatcher = DispatchingGptAgent.new(gpt_client: @gpt_client)
      @agent1 = TodoGptAgent.new(gpt_client: @gpt_client)
      @agent2 = CalendarGptAgent.new(gpt_client: @gpt_client)

      @dispatcher.register(@agent1)
      @dispatcher.register(@agent2)
    end

    def test_dispatching_prompt
      request = Request.new("I need to buy some bread")

      expected = "The following is a list of Assistants and a description of what each can do: \n\nAgents::TodoGptAgent: I am an AI Assistant that specializes in Todo List and Reminders Management.\n\nAgents::CalendarGptAgent: I am an AI Assistant that specializes in Calendar and Scheduling Management for Appointments, meetings, etc.Please categorize the request by typing the name of the Assistant that best fits the request.\n\nRequest: I need to buy some bread"

      assert_equal(expected, @dispatcher.prompt_for_categorizing_request(request: request))
    end

  end
end