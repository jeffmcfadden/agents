module Agents
  class Agent
    attr_reader :actions

    def initialize(actions: [])
      @actions = actions
    end

    # @param [Request] request
    # @return [Response] response
    def handle(request:)
      Response.new("Sorry, this agent doesn't know how to handle requests.")
    end

    def register(action:)
      @actions << action
    end

    def unregister(action:)
      @actions.delete(action)
    end

  end
end