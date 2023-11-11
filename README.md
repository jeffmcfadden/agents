# agents

A ruby library for building and managing AI agents within your application.

## Getting Started

Gemfile:

```ruby
gem 'ruby-agents'
```

`bundle install`

### OR

```shell
$ gem install ruby-agents
```

```ruby
require 'agents'
```


## Usage

```ruby
  require 'agents'
```

### Built-in Agents

### Building Your Own Agents

### Using a Dispatcher

### Running Actions


## Prompt Injection
At this time there is no built-in protection from prompt injection/jailbreak/etc. 

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