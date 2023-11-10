module Agents
  class Request
    attr_reader :request_text
    def initialize(request_text)
      @request_text = request_text
    end
  end
end