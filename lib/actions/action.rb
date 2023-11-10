module Agents

  # Takes a block and executes it when the action is called.
  class Action
    attr_reader :name, :description, :arguments, :examples

    # Create a new action
    # @param [String] name
    # @param [String] description
    # @param [Array<ActionArgument>] arguments
    # @param [Array<ActionExample>] examples
    # @param [Block] block
    def initialize(name:, description: "", arguments: [], examples: [], &block)
      @name = name
      @description = description
      @arguments = arguments
      @examples = examples
      @block = block
    end

    # Execute the block with the given arguments.
    def call(args)
      @block.call(args)
    end

    def for_prompt
      s = "#{name}: #{description}\n"

      unless arguments.empty?
        s << "  Arguments:\n"
        s << arguments.collect(&:for_prompt).join("\n") << "\n"
      end

      unless examples.empty?
        s << "  For example:\n"
        s << examples.collect(&:for_prompt).join("\n") << "\n"
      end

      s
    end

  end
end