require_relative 'logger'
require_relative 'version'

require 'openai' rescue nil # OpenAI is optional

require_relative 'gpt_clients/gpt_client'
require_relative 'gpt_clients/echo_gpt_client'

if defined?(::OpenAI::Client)
  require_relative 'gpt_clients/open_ai_gpt_client'
end

require_relative 'agents/agent'
require_relative 'agents/calendar_gpt_agent'
require_relative 'agents/categorizing_gpt_agent'
require_relative 'agents/dispatching_gpt_agent'
require_relative 'agents/information_retrieval_gpt_agent'
require_relative 'agents/promptless_gpt_agent'
require_relative 'agents/todo_gpt_agent'

require_relative 'agents/unhandleable_request_agent'

require_relative 'requests/request'

require_relative 'responses/response'
require_relative 'responses/gpt_response'
require_relative 'responses/unhandleable_request_response'

require_relative 'actions/action'
require_relative 'actions/action_argument'
require_relative 'actions/action_example'
require_relative 'actions/ask_for_clarification_action'
require_relative 'actions/delegate_action'
