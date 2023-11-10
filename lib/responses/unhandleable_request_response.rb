module Agents
  class UnhandleableRequestResponse < Response
    def initialize(request:)
      super("Sorry, I'm not sure how to handle that.")
    end
  end

end