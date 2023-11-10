module Agents
  class ActionArgument
    attr_reader :name, :type, :description
    def initialize(name:, type:, description:)
      @name = name
      @type = type
      @description = description
    end

    def for_prompt
      "    #{name}: #{description}"
    end
  end
end