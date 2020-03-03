# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/file_shared_examples.rb'

RSpec.describe Cocina::Models::File do
  let(:file_type) { 'http://cocina.sul.stanford.edu/models/file.jsonld' }
  let(:required_properties) do
    {
      externalIdentifier: 'druid:ab123cd4567',
      label: 'My file',
      type: file_type,
      version: 3
    }
  end

  it_behaves_like 'it has file attributes'

  context 'when externalIdentifier is missing' do
    let(:item) { described_class.new(required_properties.reject { |k, _v| k == :externalIdentifier }) }

    it 'raises a Dry::Struct::Error' do
      err_msg = '[Cocina::Models::File.new] :externalIdentifier is missing in Hash input'
      expect { item }.to raise_error(Dry::Struct::Error, err_msg)
    end
  end

  describe 'Checkable model methods' do
    subject { described_class.new(required_properties) }

    it { is_expected.not_to be_admin_policy }
    it { is_expected.not_to be_collection }
    it { is_expected.not_to be_dro }
    it { is_expected.to be_file }
    it { is_expected.not_to be_file_set }
  end
end
