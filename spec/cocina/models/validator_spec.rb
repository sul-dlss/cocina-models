# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validator do
  # AdminPolicy.externalIdentifier must be a valid druid
  context 'when valid' do
    let(:policy) do
      Cocina::Models::AdminPolicy.new(
        externalIdentifier: 'druid:bc123df4567',
        label: 'My admin policy',
        type: Cocina::Models::Vocab.admin_policy,
        version: 1,
        administrative: { hasAdminPolicy: 'druid:bc123df4567' }
      )
    end

    it 'does not raise' do
      expect(policy.externalIdentifier).to eq('druid:bc123df4567')
    end
  end

  describe 'when invalid' do
    let(:policy) do
      Cocina::Models::AdminPolicy.new(
        externalIdentifier: 'druid:abc123',
        label: 'My admin policy',
        type: Cocina::Models::Vocab.admin_policy,
        version: 1,
        administrative: {}
      )
    end

    it 'raises' do
      expect { policy }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'when validate=false' do
    let(:policy) do
      Cocina::Models::AdminPolicy.new({
                                        externalIdentifier: 'druid:abc123',
                                        label: 'My admin policy',
                                        type: Cocina::Models::Vocab.admin_policy,
                                        version: 1,
                                        administrative: { hasAdminPolicy: 'druid:bc123df4567' }
                                      }, false, false)
    end

    it 'does not openapi validate' do
      expect(policy.externalIdentifier).to eq('druid:abc123')
    end
  end
end
