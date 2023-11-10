module Agents
  class ActionExample
    attr_reader :input, :output
    def initialize(input:, output:)
      @input = input
      @output = output
    end

    def for_prompt
      "    Input: #{input}\n    Output: #{output}"
    end

  end
end