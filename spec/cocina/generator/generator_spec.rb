# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Generator::Generator do
  # This tests the outcome of running exe/generator generate against openapi.yml.
  it 'generates vocab' do
    expect(File.exist?('lib/cocina/models/vocab.rb')).to be true
  end

  it 'generates models for schemas' do
    expect(File.exist?('lib/cocina/models/dro.rb')).to be true
    expect(File.exist?('lib/cocina/models/request_dro.rb')).to be true
  end

  it 'leaves files alone' do
    expect(File.exist?('lib/cocina/models/version.rb')).to be true
    expect(File.exist?('lib/cocina/models/checkable.rb')).to be true
    expect(File.exist?('lib/cocina/models/validator.rb')).to be true
  end
end
