# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/admin_policy_shared_examples.rb'

RSpec.describe Cocina::Models::AdminPolicy do
  let(:type) { Cocina::Models::Vocab.admin_policy }
  # TODO: Allowing description to be omittable for now (until rolled out to consumers),
  # but I think it's actually required for every admin policy
  let(:required_properties) do
    {
      externalIdentifier: 'druid:bc123df4567',
      label: 'My admin_policy',
      type: type,
      version: 3,
      administrative: {}
    }
  end

  it_behaves_like 'it has admin_policy attributes'

  context 'when externalIdentifier is missing' do
    let(:admin_policy) { described_class.new(required_properties.reject { |k, _v| k == :externalIdentifier }) }

    it 'raises a Cocina::Models::ValidationError' do
      expect { admin_policy }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'Checkable model methods' do
    subject { described_class.new(required_properties) }

    it { is_expected.to be_admin_policy }
    it { is_expected.not_to be_collection }
    it { is_expected.not_to be_dro }
    it { is_expected.not_to be_file }
    it { is_expected.not_to be_file_set }
  end
end
