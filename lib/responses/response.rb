module Agents
  class Response
    attr_reader :response_text
    def initialize(response_text)
      @response_text = response_text
    end
  end
end