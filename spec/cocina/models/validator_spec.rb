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
        administrative: {
          hasAdminPolicy: 'druid:bc123df4567',
          hasAgreement: 'druid:bc123df4567'
        }
      )
    end

    it 'does not raise' do
      expect(policy.externalIdentifier).to eq('druid:bc123df4567')
    end
  end

  context 'when cocina version is omitted' do
    let(:policy) do
      Cocina::Models::AdminPolicy.new(
        externalIdentifier: 'druid:bc123df4567',
        label: 'My admin policy',
        type: Cocina::Models::Vocab.admin_policy,
        version: 1,
        administrative: {
          hasAdminPolicy: 'druid:bc123df4567',
          hasAgreement: 'druid:bc123df4567'
        }
      )
    end

    it 'injects cocina version' do
      expect(policy.cocinaVersion).to eq(Cocina::Models::VERSION)
    end
  end

  context 'when cocina version is present' do
    let(:policy) do
      Cocina::Models::AdminPolicy.new(
        cocinaVersion: '1.0.0',
        externalIdentifier: 'druid:bc123df4567',
        label: 'My admin policy',
        type: Cocina::Models::Vocab.admin_policy,
        version: 1,
        administrative: {
          hasAdminPolicy: 'druid:bc123df4567',
          hasAgreement: 'druid:bc123df4567'
        }
      )
    end

    it 'does not inject cocina version' do
      expect(policy.cocinaVersion).to eq('1.0.0')
    end
  end

  context 'when a nil value is passed' do
    let(:policy) do
      Cocina::Models::AdminPolicy.new(
        externalIdentifier: 'druid:bc123df4567',
        label: 'My admin policy',
        type: Cocina::Models::Vocab.admin_policy,
        version: 1,
        administrative: {
          defaultAccess: { copyright: nil },
          hasAdminPolicy: 'druid:bc123df4567',
          hasAgreement: 'druid:bc123df4567'
        }
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

  context 'when has a DateTime' do
    # This makes sure that something like following does not raise a validation error due to DateTime:
    # dro_hash = dro.to_h
    # Change the hash.
    # Cocina::Models::DRO.new(dro_hash)
    let(:dro) do
      Cocina::Models::DRO.new(
        {
          type: 'http://cocina.sul.stanford.edu/models/image.jsonld',
          externalIdentifier: 'druid:bb000kg4251',
          label: 'Roger Howe Professorship',
          version: 3,
          access: {
            access: 'world',
            download: 'world',
            useAndReproductionStatement: 'Property rights reside with the repository.'
          },
          administrative: {
            hasAdminPolicy: 'druid:ww057vk7675',
            releaseTags: [
              {
                who: 'cspitzer',
                what: 'self',
                date: DateTime.new,
                to: 'Searchworks',
                release: true
              }
            ],
            partOfProject: 'School of Engineering photograph collection'
          }
        }
      )
    end

    it 'does not raise' do
      dro
    end
  end

  describe 'when validate=false' do
    let(:policy) do
      Cocina::Models::AdminPolicy.new({
                                        externalIdentifier: 'druid:abc123',
                                        label: 'My admin policy',
                                        type: Cocina::Models::Vocab.admin_policy,
                                        version: 1,
                                        administrative: {
                                          hasAdminPolicy: 'druid:bc123df4567',
                                          hasAgreement: 'druid:bc123df4567'
                                        }
                                      }, false, false)
    end

    it 'does not openapi validate' do
      expect(policy.externalIdentifier).to eq('druid:abc123')
    end
  end
end
