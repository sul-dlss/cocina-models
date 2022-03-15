# frozen_string_literal: true

require 'rspec/core'
require 'rspec/matchers'
require 'super_diff/rspec'
require 'cocina/rspec/matchers'

RSpec.configure do |config|
  config.include Cocina::RSpec::Matchers
end
