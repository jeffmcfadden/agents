module Agents
  class TodoGptAgent < Agent

    def initialize(**args)
      super(**args)
      @description = "I am an AI Assistant that specializes in Todo List and Reminders Management."
      @system_prompt = <<~EOS
        You are a helpful assistant specializing in Todo List and Reminders Management. Please do your best to complete
        any requests you are given. For each request, please respond ONLY with a JSON object. The JSON object should have
        two top-level keys: `response` and `actions`. The `response` key should be a short string that summarizes the actions
        to be taken. The `actions` key should be an array of JSON objects, each of which has a `name` key and an `args` key.
        If you aren't sure what actions should be taken, or you don't think there's anything relevant, then respond with
        an empty array for the `actions` key.
        
        
      EOS
    end

    def system_prompt
      prompt = @system_prompt

      unless self.actions.empty?
        prompt << "The following actions are supported: \n"
        prompt << self.actions.collect(&:for_prompt).join("\n\n")
      end

      prompt << "\n\n"
    end

  end
end