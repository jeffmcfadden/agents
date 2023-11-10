require 'agents'

module Agents
  class TestDispatcher < TLDR

    def setup
      @dispatcher = Dispatcher.new
      @agent1 = Agent.new
      @agent2 = Agent.new

      @echo_agent = EchoAgent.new
    end

    def test_registration
      @dispatcher.register(@agent1)
      @dispatcher.register(@agent2)
      assert_equal(@dispatcher.agents, [@agent1, @agent2])
    end

    def test_unregistration
      @dispatcher.register(@agent1)
      @dispatcher.register(@agent2)
      @dispatcher.unregister(@agent1)
      assert_equal(@dispatcher.agents, [@agent2])
    end

    def test_default_handling
      @dispatcher.register(@echo_agent)

      # Default handling is to select a random agent. In this case we have a single
      # echoing agent, so we expect the codepath to be exercised, but we know it will
      # always be that one agent.
      response = @dispatcher.handle(request: Request.new("Test Request"))
      assert_equal("Test Request", response.response_text )
    end

  end
end