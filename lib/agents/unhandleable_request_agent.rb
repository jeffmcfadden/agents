module Agents
  class UnhandleableRequestAgent
    def handle(request:)
      return UnhandleableRequestResponse.new(request: request)
    end
  end

end