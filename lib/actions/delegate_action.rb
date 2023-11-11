module Agents
  module Actions
    class DelegateAction < Action
      def initialize(handler:)
        super(name: "delegate",
              description: "Delegate to another agent",
              arguments: [
                ActionArgument.new(name: "agent", type: "String", description: "The name of the agent to delegate the request to.")
              ]
        )
        @handler = handler
      end

      def perform(request:, args:)
        @handler.delegate_request(request: request, args: args)
      end
    end

  end
end