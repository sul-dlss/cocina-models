# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/collection_shared_examples.rb'

RSpec.describe Cocina::Models::Collection do
  let(:collection_type) { Cocina::Models::Vocab.collection }
  let(:required_properties) do
    {
      externalIdentifier: 'druid:ab123cd4567',
      type: collection_type,
      label: 'My collection',
      version: 3
    }
  end

  it_behaves_like 'it has collection attributes'

  context 'when externalIdentifier is missing' do
    let(:instance) { described_class.new(required_properties.reject { |k, _v| k == :externalIdentifier }) }

    it 'raises a Dry::Struct::Error' do
      err_msg = '[Cocina::Models::Collection.new] :externalIdentifier is missing in Hash input'
      expect { instance }.to raise_error(Dry::Struct::Error, err_msg)
    end
  end

  describe 'Checkable model methods' do
    subject(:collection) { described_class.new(required_properties) }

    it { is_expected.not_to be_admin_policy }
    it { is_expected.to be_collection }
    it { is_expected.not_to be_dro }
    it { is_expected.not_to be_file }
    it { is_expected.not_to be_file_set }
  end

  describe Cocina::Models::Collection::Administrative do
    let(:instance) { described_class.new }

    describe ':hasAdminPolicy default is nil' do
      subject { instance.hasAdminPolicy }

      it { is_expected.to be_nil }
    end

    describe ':releaseTags default is empty array' do
      subject { instance.releaseTags }

      it { is_expected.to eq [] }
    end
  end
end
