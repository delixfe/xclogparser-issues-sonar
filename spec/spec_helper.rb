# frozen_string_literal: true

require "json"
require "converter"
require_relative "spec_matcher"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include IssueMatcher
end



def fixture(file)
  File.read("spec/fixtures/#{file}")
end

def json_fixture(file)
  content = fixture("#{file}.json")
  content = JSON.parse(content)

  content
end
