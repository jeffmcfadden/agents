module Agents
  class Dispatcher < Agent
    attr_reader :agents
    def initialize(agents: [], **args)
      super(**args)
      @agents = agents
    end

    def register(agent)
      @agents << agent
    end

    def unregister(agent)
      @agents.delete(agent)
    end

    def handle(request:)
      agent = agent_for_request(request: request)
      agent.handle(request: request)
    end

    # Default behavior is a random agent. Use a subclass to specify behavior.
    def agent_for_request(request:)
      return UnhandleableRequestAgent.new if agents.empty?

      @agents.shuffle.first
    end
  end
end