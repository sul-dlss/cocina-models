# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/collection_shared_examples.rb'

RSpec.describe Cocina::Models::Collection do
  let(:collection_type) { Cocina::Models::Vocab.collection }
  let(:required_properties) do
    {
      externalIdentifier: 'druid:bc123df4567',
      type: collection_type,
      label: 'My collection',
      version: 3,
      access: {}
    }
  end

  it_behaves_like 'it has collection attributes'

  context 'when externalIdentifier is missing' do
    let(:instance) { described_class.new(required_properties.reject { |k, _v| k == :externalIdentifier }) }

    it 'raises a Cocina::Models::ValidationError' do
      expect { instance }.to raise_error(Cocina::Models::ValidationError)
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

  describe Cocina::Models::Administrative do
    let(:instance) { described_class.new }

    describe ':hasAdminPolicy default is nil' do
      subject { instance.hasAdminPolicy }

      it { is_expected.to be_nil }
    end

    describe ':releaseTags default is nil' do
      subject { instance.releaseTags }

      it { is_expected.to be_nil }
    end
  end
end
