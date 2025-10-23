# frozen_string_literal: true

require 'bundler/setup'
require 'cocina/models'
require 'cocina/rspec'
require 'debug'
require 'equivalent-xml/rspec_matchers'
require 'support/mods_mapping_spec_helper'
require 'support/matchers/deep_ignore_order_matcher'
require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
  if ENV['CI']
    require 'simplecov_json_formatter'

    formatter SimpleCov::Formatter::JSONFormatter
  end
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

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random unless config.files_to_run.one?

  # it's useful to allow more verbose output when running a single spec file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end
end
