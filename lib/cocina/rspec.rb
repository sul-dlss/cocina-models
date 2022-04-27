# frozen_string_literal: true

require 'rspec/core'
require 'rspec/matchers'
require 'super_diff/rspec'
require 'cocina/rspec/matchers'
require 'cocina/rspec/factories'

RSpec.configure do |config|
  config.include Cocina::RSpec::Matchers
  config.include Cocina::RSpec::Factories::Methods
end
