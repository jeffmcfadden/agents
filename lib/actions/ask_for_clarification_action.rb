# frozen_string_literal: true

module Agents
  module Actions
    class AskForClarificationAction < Action
      def initialize
        super(name: "ask_for_clarification",
              description: "Ask for clarification if the request is not clear, or you don't know how to help.",
              arguments: [ActionArgument.new(name: "question", type: "String", description: "The question, clarification, or additional information you need.")],
        )
      end

      def perform(request:, args:)
        args.dig("question")
      end
    end

  end
end