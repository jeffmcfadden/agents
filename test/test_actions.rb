require 'agents'

module Agents
  class TestActions < TLDR

    def setup
      @gpt_client = EchoGptClient.new
      @dispatcher = DispatchingGptAgent.new(gpt_client: @gpt_client)
      @agent = InformationRetrievalGptAgent.new(gpt_client: @gpt_client)

      @dispatcher.register(@agent)
    end

    def test_dispatching_prompt
      test_action = Action.new(name: "test_action") do |**args|
        return "This is a test action"
      end

      @agent.register(action: test_action)

      # This is a JSON payload because the EchoGPTClient will echo this back as the response
      test_payload = { response: "I performed the test action for you", actions: [{ name: "test_action", args: {} }] }

      test_request = Request.new(test_payload.to_json)

      response = @agent.handle(request: test_request)

      assert_equal response.raw_text, test_payload.to_json
      assert_equal response.response_text, "I performed the test action for you"
      assert_equal response.suggested_actions.size, 1
    end


    class TestablePerformingAction < Action

      attr_reader :was_performed
      def initialize(**args)
        super(**args)
        @was_performed = false
      end

      def call(**args)
        super(**args)
        @was_performed = true
      end
    end

    class TestActionPerformingGptAgent < GptAgent

    end

    def test_performing_action
      test_action = TestablePerformingAction.new(name: "test_action") do
        return "This is a test action"
      end

      agent = TestActionPerformingGptAgent.new(gpt_client: @gpt_client, system_prompt: "This is a test prompt", description: "This is a test description")

      assert_equal false, test_action.was_performed

      agent.register(action: test_action)

      # This is a JSON payload because the EchoGPTClient will echo this back as the response
      test_payload = { response: "I performed the test action for you", actions: [{ name: "test_action", args: {} }] }

      test_request = Request.new(test_payload.to_json)
      response = agent.handle(request: test_request)

      assert_equal true, test_action.was_performed
      assert_equal "I performed the test action for you", response.response_text
    end

  end
end