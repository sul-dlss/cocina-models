# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::JsonSchemaValidator do
  subject(:validate) { validator.validate }

  let(:validator) { described_class.new(clazz, props) }
  let(:clazz) { Cocina::Models::AdminPolicy }
  let(:props) do
    {
      externalIdentifier: 'druid:bc123df4567',
      label: 'My admin policy',
      type: Cocina::Models::ObjectType.admin_policy,
      version: 1,
      administrative: {
        hasAdminPolicy: 'druid:bc123df4567',
        hasAgreement: 'druid:bc123df4567',
        accessTemplate: {}
      }
    }
  end

  context 'with an unexpected property' do
    let(:props) do
      {
        externalIdentifier: 'druid:bc123df4567',
        label: 'My admin policy',
        type: Cocina::Models::ObjectType.admin_policy,
        version: 1,
        administrative: {
          accessTemplate: {},
          hasAdminPolicy: 'druid:bc123df4567',
          hasAgreement: 'druid:bc123df4567',
          releaseTags: [{to: 'Searchworks', who: 'mjgiarlo', what: 'self', release: true}]
        }
      }
    end

    it 'raises ValidationError' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError,
                                         %r{\AWhen validating AdminPolicy: object property at `/administrative/releaseTags` is a disallowed unevaluated property\z})
    end
  end

  describe 'unevaluatedProperties error reporting' do
    let(:clazz) { double(name: 'Cocina::Models::AdminPolicy', attribute_names: %i[cocinaVersion externalIdentifier label type version administrative]) }
    let(:props) { {} }
    let(:schema_double) { instance_double(JSONSchemer::Schema) }
    let(:ref_double) { instance_double(JSONSchemer::Schema) }

    before do
      allow(validator).to receive(:schema).and_return(schema_double)
      allow(schema_double).to receive(:ref).with('#/$defs/AdminPolicy').and_return(ref_double)
      allow(ref_double).to receive(:validate).and_return(errors)
    end

    context 'when root-level unevaluatedProperties errors are cascaded noise' do
      let(:errors) do
        [
          {
            'data_pointer' => '/administrative/releaseTags',
            'error' => 'object property at `/administrative/releaseTags` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AdminPolicyAdministrative/unevaluatedProperties'
          },
          {
            'data_pointer' => '/externalIdentifier',
            'error' => 'object property at `/externalIdentifier` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AdminPolicy/unevaluatedProperties'
          },
          {
            'data_pointer' => '/label',
            'error' => 'object property at `/label` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AdminPolicy/unevaluatedProperties'
          },
          {
            'data_pointer' => '/type',
            'error' => 'object property at `/type` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AdminPolicy/unevaluatedProperties'
          },
          {
            'data_pointer' => '/version',
            'error' => 'object property at `/version` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AdminPolicy/unevaluatedProperties'
          },
          {
            'data_pointer' => '/administrative',
            'error' => 'object property at `/administrative` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AdminPolicy/unevaluatedProperties'
          },
          {
            'data_pointer' => '/cocinaVersion',
            'error' => 'object property at `/cocinaVersion` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AdminPolicy/unevaluatedProperties'
          }
        ]
      end

      it 'filters known root properties while keeping nested errors' do
        expect { validate }.to raise_error(
          Cocina::Models::ValidationError,
          'When validating AdminPolicy: object property at `/administrative/releaseTags` is a disallowed unevaluated property'
        )
      end
    end

    context 'when bogus props exist at root and deeply nested positions' do
      let(:errors) do
        [
          {
            'data_pointer' => '/administrative/roles/0/bogusProperty',
            'error' => 'object property at `/administrative/roles/0/bogusProperty` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AccessRole/unevaluatedProperties'
          },
          {
            'data_pointer' => '/bogusRoot',
            'error' => 'object property at `/bogusRoot` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AdminPolicy/unevaluatedProperties'
          },
          {
            'data_pointer' => '/label',
            'error' => 'object property at `/label` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AdminPolicy/unevaluatedProperties'
          }
        ]
      end

      it 'includes both root and deeply nested bogus properties' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError) { |error|
          expect(error.message).to include('object property at `/bogusRoot` is a disallowed unevaluated property')
          expect(error.message).to include('object property at `/administrative/roles/0/bogusProperty` is a disallowed unevaluated property')
          expect(error.message).not_to include('object property at `/label` is a disallowed unevaluated property')
        }
      end
    end

    context 'when bogus props exist at root and at two nested depths' do
      let(:errors) do
        [
          {
            'data_pointer' => '/administrative/accessTemplate/unknownLeaf',
            'error' => 'object property at `/administrative/accessTemplate/unknownLeaf` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AdminPolicyAccessTemplate/unevaluatedProperties'
          },
          {
            'data_pointer' => '/administrative/roles/0/members/0/unknownLeaf',
            'error' => 'object property at `/administrative/roles/0/members/0/unknownLeaf` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AccessRoleMember/unevaluatedProperties'
          },
          {
            'data_pointer' => '/bogusRoot',
            'error' => 'object property at `/bogusRoot` is a disallowed unevaluated property',
            'schema_pointer' => '/$defs/AdminPolicy/unevaluatedProperties'
          }
        ]
      end

      it 'keeps root and both nested bogus properties' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError) { |error|
          expect(error.message).to include('object property at `/bogusRoot` is a disallowed unevaluated property')
          expect(error.message).to include('object property at `/administrative/roles/0/members/0/unknownLeaf` is a disallowed unevaluated property')
          expect(error.message).to include('object property at `/administrative/accessTemplate/unknownLeaf` is a disallowed unevaluated property')
        }
      end
    end
  end

  # AdminPolicy.externalIdentifier must be a valid druid
  context 'when valid' do
    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when cocina version is omitted' do
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
        type: Cocina::Models::ObjectType.admin_policy,
        version: 1,
        administrative: {
          hasAdminPolicy: 'druid:bc123df4567',
          hasAgreement: 'druid:bc123df4567',
          accessTemplate: {}
        }
      )
    end

    it 'does not inject cocina version' do
      expect(policy.cocinaVersion).to eq('1.0.0')
    end
  end

  context 'when a nil copyright value (nullable string) is passed' do
    let(:props) do
      {
        externalIdentifier: 'druid:bc123df4567',
        label: 'My admin policy',
        type: Cocina::Models::ObjectType.admin_policy,
        version: 1,
        administrative: {
          accessTemplate: { copyright: nil },
          hasAdminPolicy: 'druid:bc123df4567',
          hasAgreement: 'druid:bc123df4567'
        }
      }
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when a nil barcode value (nullable oneOf) is passed' do
    let(:props) do
      {
        externalIdentifier: 'druid:bc123df4567',
        label: 'My item',
        type: Cocina::Models::ObjectType.object,
        version: 1,
        description: {
          title: [{ value: 'Test DRO' }],
          purl: 'https://purl.stanford.edu/bc123df4567'
        },
        administrative: {
          hasAdminPolicy: 'druid:bc123df4567'
        },
        access: {},
        identification: {
          barcode: nil,
          sourceId: 'sul:123'
        },
        structural: {}
      }
    end

    let(:clazz) { Cocina::Models::DRO }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'union types' do
    let(:props) do
      {
        externalIdentifier: 'druid:bc123df4567',
        label: 'My item',
        type: Cocina::Models::ObjectType.object,
        version: 1,
        description: {
          title: [{ value: 'Test DRO' }],
          purl: 'https://purl.stanford.edu/bc123df4567'
        },
        administrative: {
          hasAdminPolicy: 'druid:bc123df4567'
        },
        access: {},
        identification: {
          barcode: barcode,
          sourceId: 'sul:123'
        },
        structural: {}
      }
    end

    let(:clazz) { Cocina::Models::DRO }

    context 'with a business barcode' do
      let(:barcode) { '20501234567' }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'with a lane medical barcode' do
      let(:barcode) { '24512345678' }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'with a catkey barcode' do
      let(:barcode) { '12345-67890' }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'with a standard barcode' do
      let(:barcode) { '36105123456789' }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'with a California Historical Society (CHS) barcode' do
      let(:barcode) { '405000111956' }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end
  end

  context 'when invalid' do
    let(:props) do
      {
        externalIdentifier: 'druid:abc123',
        label: 'My admin policy',
        type: Cocina::Models::ObjectType.admin_policy,
        version: 1,
        administrative: {}
      }
    end

    it 'raises' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when a filename contains a newline character' do
    let(:clazz) { Cocina::Models::DRO }

    let(:props) do
      {
        externalIdentifier: 'druid:bc123df4567',
        label: 'My item',
        type: Cocina::Models::ObjectType.book,
        version: 1,
        description: {
          title: [{ value: 'Test DRO' }],
          purl: 'https://purl.stanford.edu/bc123df4567'
        },
        administrative: { hasAdminPolicy: 'druid:bc123df4567' },
        access: { view: 'world', download: 'world' },
        structural: {
          contains: [
            {
              externalIdentifier: 'bc123df4567_1',
              label: 'Fileset 1',
              type: Cocina::Models::FileSetType.file,
              version: 1,
              structural: {
                contains: [
                  {
                    externalIdentifier: 'bc123df4567_1',
                    label: 'Page 1',
                    type: Cocina::Models::ObjectType.file,
                    version: 1,
                    access: { view: 'world', download: 'world' },
                    administrative: { publish: true, shelve: true, sdrPreserve: true },
                    hasMessageDigests: [],
                    filename: "file\nname.txt"
                  }
                ]
              }
            }
          ]
        }
      }
    end

    it 'raises' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when has a DateTime' do
    # This makes sure that something like following does not raise a validation error due to DateTime:
    # dro_hash = dro.to_h
    # Change the hash.
    # Cocina::Models::DRO.new(dro_hash)
    let(:props) do
      {
        type: 'https://cocina.sul.stanford.edu/models/image',
        externalIdentifier: 'druid:bb000kg4251',
        label: 'Roger Howe Professorship',
        version: 3,
        description: {
          title: [{ value: 'Test DRO' }],
          purl: 'https://purl.stanford.edu/bb000kg4251'
        },
        access: {
          view: 'world',
          download: 'world',
          useAndReproductionStatement: 'Property rights reside with the repository.'
        },
        administrative: {
          hasAdminPolicy: 'druid:ww057vk7675'
        },
        structural: {},
        identification: { sourceId: 'sul:123' }
      }
    end

    let(:clazz) { Cocina::Models::DRO }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end
end
