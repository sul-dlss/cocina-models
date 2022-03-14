# frozen_string_literal: true

require 'rspec/core'
require 'rspec/matchers'
if defined?(Rails)
  require 'super_diff/rspec-rails'
else
  require 'super_diff/rspec'
end
require 'cocina/rspec/matchers'

RSpec.configure do |config|
  config.include Cocina::RSpec::Matchers
end
