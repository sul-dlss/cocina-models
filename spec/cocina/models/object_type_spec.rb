# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::ObjectType do
  it 'provides vocab methods' do
    expect(described_class.admin_policy).to eq('http://cocina.sul.stanford.edu/models/admin_policy.jsonld')
    expect(described_class.webarchive_seed).to eq('http://cocina.sul.stanford.edu/models/webarchive-seed.jsonld')
  end

  it 'handles special 3d case' do
    expect(described_class.three_dimensional).to eq('http://cocina.sul.stanford.edu/models/3d.jsonld')
  end
end
