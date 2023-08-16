# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Generator::Schema do
  # This tests the outcome of running exe/generator generate against openapi.yml.
  context 'when properties' do
    # RequestFile.administrative is an object attribute.
    # RequestFile.hasMessageDigests is an array attribute.
    # RequestFile.label is a value (string) attribute.
    let(:file) do
      Cocina::Models::RequestFile.new(
        externalIdentifier: 'druid:ab123cd4567',
        label: 'morris.exe',
        filename: 'morris.exe',
        type: 'https://cocina.sul.stanford.edu/models/file',
        version: 3,
        administrative: {
          shelve: true,
          sdrPreserve: true
        },
        hasMessageDigests: [
          {
            type: 'md5',
            digest: 'd57db4241d7da0eecba5b33abf13f448'
          },
          {
            type: 'sha1',
            digest: '600a43324ea40ae1ba0c7ffa83965830d384c086'
          }
        ]
      )
    end

    it 'generates object attributes' do
      expect(file.administrative.shelve).to be true
    end

    it 'generates array attributes' do
      expect(file.hasMessageDigests.size).to eq(2)
    end

    it 'generates value attributes' do
      expect(file.label).to eq('morris.exe')
    end
  end

  context 'when allOf' do
    # DescriptiveValue is allOf DescriptiveBasicValue, DescriptiveStructuredValue, AppliesTo
    let(:value) do
      Cocina::Models::DescriptiveValue.new(
        value: 'foo',
        structuredValue: [{ value: 'bar' }],
        appliesTo: [{ value: 'foobar' }]
      )
    end

    it 'generates attributes from all schemas' do
      expect(value.value).to eq('foo')
      expect(value.structuredValue.first.value).to eq('bar')
      expect(value.appliesTo.first.value).to eq('foobar')
    end
  end

  context 'when schema has types' do
    let(:policy) do
      Cocina::Models::AdminPolicy.new(
        externalIdentifier: 'druid:bc123df4567',
        label: 'My admin policy',
        type: Cocina::Models::ObjectType.admin_policy,
        version: 1,
        administrative: {
          hasAdminPolicy: 'druid:bc123df4567',
          hasAgreement: 'druid:bc123df4567',
          accessTemplate: {}
        }
      )
    end

    it 'is checkable' do
      expect(policy.admin_policy?).to be true
      expect(policy.dro?).to be false
    end
  end

  context 'when schema references another custom type' do
    let(:policy) do
      Cocina::Models::AdminPolicy.new(
        {
          externalIdentifier: 'druid:iaminvalid',
          label: 'My admin policy',
          type: Cocina::Models::ObjectType.admin_policy,
          version: 1,
          administrative: {
            hasAdminPolicy: 'druid:bc123df4567',
            hasAgreement: 'druid:bc123df4567',
            accessTemplate: {}
          }
        }, false, false
      )
    end

    it 'does not validate' do
      expect { policy }.to raise_error(Dry::Struct::Error)
    end
  end

  context 'when validatable' do
    # A model is validatable when there is a validation path in the openapi. For example, /validate/AdminPolicy
    # Its initializer then accepts a third argument which indicates whether to validate.
    let(:policy) do
      Cocina::Models::AdminPolicy.new({
                                        externalIdentifier: 'druid:abc123',
                                        label: 'My admin policy',
                                        type: Cocina::Models::ObjectType.admin_policy,
                                        version: 1,
                                        administrative: {}
                                      }, false, true)
    end

    it 'can be validated' do
      expect { policy }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when not validatable' do
    let(:administrative) { Cocina::Models::Administrative.new({}, false, true) }

    it 'cannot be validated' do
      expect { administrative }.to raise_error(ArgumentError)
    end
  end

  context 'when property has a pattern and data does not match pattern' do
    let(:catalog_link) { Cocina::Models::SymphonyCatalogLink.new({ catalog: 'symphony', catalogRecordId: 'foobar' }) }

    it 'cannot be validated' do
      expect { catalog_link }.to raise_error(Dry::Struct::Error)
    end
  end

  # NOTE: Using catalog links as an example to test
  describe 'union types' do
    let(:union_type) { Cocina::Models::CatalogLink[link_hash] }

    context 'when one of the included types is supplied' do
      let(:link_hash) { { catalog: 'symphony', catalogRecordId: '123' } }

      it 'accepts the value' do
        expect { union_type }.not_to raise_error
      end
    end

    context 'when a different one of the included types is supplied' do
      let(:link_hash) { { catalog: 'previous folio', catalogRecordId: 'a789' } }

      it 'accepts the value' do
        expect { union_type }.not_to raise_error
      end
    end

    context 'when an invalid value is supplied' do
      let(:link_hash) { { catalog: 'previous symphony', catalogRecordId: 'a789' } }

      it 'cannot be validated' do
        expect { union_type }.to raise_error(Dry::Struct::Error, /invalid type for :catalogRecordId violates constraints/)
      end
    end
  end

  describe 'lite schemas' do
    context 'when validating' do
      let(:dro) { Cocina::Models::DROLite.new({}, false, true) }

      it 'cannot be validated' do
        expect { dro }.to raise_error(ArgumentError)
      end
    end

    context 'when missing referenced attributes' do
      let(:policy) do
        Cocina::Models::AdminPolicyLite.new(
          externalIdentifier: 'druid:bc123df4567',
          label: 'My admin policy',
          type: Cocina::Models::ObjectType.admin_policy,
          version: 1
        )
      end

      it 'is relaxed' do
        expect(policy.administrative).to be_nil
      end
    end
  end
end
