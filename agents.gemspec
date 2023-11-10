# -*- encoding: utf-8 -*-
# frozen_string_literal: true

require 'logger'
require_relative 'lib/version'

Gem::Specification.new do |s|
  s.name = "agents"
  s.version     = '0.0.1' # Agents::VERSION
  s.platform    = Gem::Platform::RUBY

  s.authors = ["Jeff McFadden"]
  s.date = "2023-11-05"
  s.description = "Put AI to Work."
  s.email = "jeff@thegreenshed.org"
  s.files = `git ls-files`.split("\n")

  s.homepage = "https://github.com/jeffmcfadden/agents"
  s.require_paths = ["lib"]
  s.rubygems_version = Agents::VERSION
  s.summary = "Setup and organize requests between multiple AI agents."

  s.add_development_dependency "tldr", ">= 0.9.5"
  s.add_development_dependency "ruby-openai", ">= 5.1"
end
