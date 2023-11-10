module Agents
  class ActionExample
    attr_reader :input, :output
    def initialize(input:, output:)
      @input = input
      @output = output
    end

    def for_prompt
      "Input: #{input}\nOutput: #{output}"
    end

  end
end