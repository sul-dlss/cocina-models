# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::AdminPolicy do
  let(:type) { 'http://cocina.sul.stanford.edu/models/admin_policy.jsonld' }

  describe 'initialization' do
    subject(:admin_policy) { described_class.new(properties) }

    context 'with a minimal set' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: type,
          label: 'My admin_policy',
          version: 3
        }
      end

      it 'has properties' do
        expect(admin_policy.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(admin_policy.type).to eq type
        expect(admin_policy.label).to eq 'My admin_policy'

        expect(admin_policy.access).to be_kind_of Cocina::Models::AdminPolicy::Access
      end
    end

    context 'with a string version' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: type,
          label: 'My admin_policy',
          version: '3'
        }
      end

      it 'coerces to integer' do
        expect(admin_policy.version).to eq 3
      end
    end

    context 'with a all properties' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: type,
          label: 'My admin_policy',
          version: 3,
          access: {
          },
          administrative: {
          }
        }
      end

      it 'has properties' do
        expect(admin_policy.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(admin_policy.type).to eq type
        expect(admin_policy.label).to eq 'My admin_policy'
      end
    end
  end

  describe '.from_dynamic' do
    subject(:admin_policy) { described_class.from_dynamic(properties) }

    context 'with empty subschemas' do
      let(:properties) do
        {
          'externalIdentifier' => 'druid:kv840rx2720',
          'type' => type,
          'label' => 'Examination of the memorial of the owners and underwriters ...',
          'version' => 1,
          'access' => {},
          'administrative' => {},
          'identification' => {},
          'structural' => {}
        }
      end

      it 'has properties' do
        expect(admin_policy.externalIdentifier).to eq 'druid:kv840rx2720'
      end
    end
  end

  describe '.from_json' do
    subject(:admin_policy) { described_class.from_json(json) }

    context 'with a minimal admin_policy' do
      let(:json) do
        <<~JSON
          {
            "externalIdentifier":"druid:12343234",
            "type":"#{type}",
            "label":"my admin_policy",
            "version": 3
          }
        JSON
      end

      it 'has the attributes' do
        expect(admin_policy.attributes).to include(externalIdentifier: 'druid:12343234',
                                                   label: 'my admin_policy',
                                                   type: type)
        expect(admin_policy.access).to be_kind_of Cocina::Models::AdminPolicy::Access
        expect(admin_policy.administrative).to be_kind_of Cocina::Models::AdminPolicy::Administrative
        expect(admin_policy.identification).to be_kind_of Cocina::Models::AdminPolicy::Identification
        expect(admin_policy.structural).to be_kind_of Cocina::Models::AdminPolicy::Structural
      end
    end

    context 'with a full admin_policy' do
      let(:json) do
        <<~JSON
          {
            "externalIdentifier":"druid:12343234",
            "type":"#{type}",
            "label":"my admin_policy",
            "version": 3,
            "access": {
            },
            "administrative": {
            }
          }
        JSON
      end

      it 'has the attributes' do
        expect(admin_policy.attributes).to include(externalIdentifier: 'druid:12343234',
                                                   label: 'my admin_policy',
                                                   type: type)
      end
    end
  end
end
