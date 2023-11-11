module Agents
  class UnhandleableRequestAgent < Agent
    def handle(request:)
      return UnhandleableRequestResponse.new(request: request)
    end
  end

end