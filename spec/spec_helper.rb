# frozen_string_literal: true

require 'bundler/setup'
require 'cocina/models'
require 'cocina/rspec'
require 'byebug'

require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end

# This will find any constants that Zeitwerk has trouble inflecting
Zeitwerk::Loader.eager_load_all

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
