# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/file_shared_examples.rb'

RSpec.describe Cocina::Models::RequestFile do
  let(:file_type) { 'http://cocina.sul.stanford.edu/models/file.jsonld' }
  let(:required_properties) do
    {
      label: 'My file',
      filename: 'my_file.txt',
      type: file_type,
      version: 3
    }
  end

  it_behaves_like 'it has file attributes'

  context 'when externalIdentifier provided' do
    let(:item) { described_class.new(properties) }

    let(:properties) do
      { externalIdentifier: 'abc123' }.merge(required_properties)
    end

    it 'has externalIdentifier attribute' do
      expect(item.externalIdentifier).to eq('abc123')
    end
  end
end
