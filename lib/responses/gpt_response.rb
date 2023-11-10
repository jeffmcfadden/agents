module Agents
  # The response from a GPT request.
  class GptResponse < Response

    attr_reader :raw_text
    attr_reader :response_text
    attr_reader :suggested_actions
    attr_reader :data


    # @param [String] raw_text The raw text the GPT service returned.
    def initialize(raw_text)
      @raw_text = raw_text

      begin
        @data = extract_json_data(raw_text)
        @response_text   = data["response"] || raw_text
        @suggested_actions = data["actions"] || []
      rescue
        @data = {}
        @response_text   = raw_text
        @suggested_actions = []
      end
    end

    # TODO: Extract this into an object:
    def extract_json_data(string)
      # Check if the string is valid JSON.
      begin
        json_obj = JSON.parse(string)
        return json_obj
      rescue JSON::ParserError => error
        Agents.logger.info "Whole string was not pure JSON. #{error}"
      end

      # Search for JSON using regular expression
      match_data = string.match(/\{.*\}/m)
      if match_data
        begin
          Agents.logger.info "Found some JSON in the string."

          json_obj = JSON.parse(match_data[0])
          return json_obj
        rescue JSON::ParserError
          Agents.logger.info "Extracted string was not pure JSON. #{error}"
        end
      end
    end

  end
end