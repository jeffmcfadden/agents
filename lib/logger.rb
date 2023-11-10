#frozen_string_literal: true

require 'logger'

module Agents
  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end
end