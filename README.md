# agents

A ruby library for building and managing AI agents within your application.

## Getting Started

Gemfile:

```ruby
gem 'agents', git: "jeffmcfadden/agents"
```

`bundle install`

## Usage

```ruby
  require 'agents'
```

### Built-in Agents

### Building Your Own Agents

### Using a Dispatcher

### Running Actions


## Testing

Use `tldr` to run the tests.

```shell
$ bundle install
$ tldr --watch
```

By default, no network calls are made while testing. If you want to test the full path into OpenAI, you can run that with:

```shell
$ OPENAI_ACCESS_TOKEN="sk-123YourToken" bundle exec ruby test/test_openai.rb
```