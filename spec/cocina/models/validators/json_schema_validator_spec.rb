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
                                         /When validating AdminPolicy: Unevaluated properties are not allowed \('releaseTags' was unexpected\)/)
    end
  end

  describe 'unevaluatedProperties error reporting' do
    let(:clazz) { double(name: 'Cocina::Models::AdminPolicy', attribute_names: %i[cocinaVersion externalIdentifier label type version administrative]) }
    let(:props) { {} }
    let(:validator_double) { double('JSONSchema::Validator') } # rubocop:disable RSpec/VerifiedDoubles
    let(:evaluation_double) { double('evaluation', valid?: false) } # rubocop:disable RSpec/VerifiedDoubles

    def unevaluated_detail(instance_location:, unexpected:)
      msg = if unexpected.length == 1
              "Unevaluated properties are not allowed ('#{unexpected.first}' was unexpected)"
            else
              "Unevaluated properties are not allowed (#{unexpected.map { |p| "'#{p}'" }.join(', ')} were unexpected)"
            end
      { valid: false, instanceLocation: instance_location,
        errors: { 'unevaluatedProperties' => msg } }
    end

    def false_schema_detail(instance_location:)
      { valid: false, instanceLocation: instance_location,
        errors: { 'falseSchema' => 'False schema does not allow ...' } }
    end

    before do
      allow(described_class).to receive(:validator_for).with('AdminPolicy').and_return(validator_double)
      allow(validator_double).to receive(:evaluate).and_return(evaluation_double)
      allow(evaluation_double).to receive(:list).and_return({ details: details })
    end

    context 'when root-level unevaluatedProperties errors are cascaded noise' do
      # Real error: at /administrative (nested object), unexpected = ['releaseTags']
      # Noise: root "" (all unexpected are known model attributes) + falseSchema cascade entries
      let(:details) do
        [
          unevaluated_detail(instance_location: '/administrative', unexpected: %w[releaseTags]),
          unevaluated_detail(instance_location: '', unexpected: %w[externalIdentifier label type version administrative cocinaVersion]),
          false_schema_detail(instance_location: '/administrative'),
          false_schema_detail(instance_location: '/externalIdentifier')
        ]
      end

      it 'filters out cascade noise while keeping the nested error' do
        expect { validate }.to raise_error(
          Cocina::Models::ValidationError,
          "When validating AdminPolicy: Unevaluated properties are not allowed ('releaseTags' was unexpected) at /administrative"
        )
      end
    end

    context 'when bogus props exist at root and deeply nested positions' do
      # Real errors: nested bogus property + root bogus property mixed with cascade props
      # The root error includes 'bogusRoot' (unknown) so it is kept; known props are cascade
      # but are bundled with 'bogusRoot' in the same kept error.
      let(:details) do
        [
          unevaluated_detail(instance_location: '/administrative/roles/0', unexpected: %w[bogusProperty]),
          unevaluated_detail(instance_location: '', unexpected: %w[bogusRoot administrative externalIdentifier label type version]),
          false_schema_detail(instance_location: '/administrative')
        ]
      end

      it 'includes both root and deeply nested bogus properties' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError) { |error|
          expect(error.message).to include("'bogusRoot'")
          expect(error.message).to include("'bogusProperty'")
        }
      end
    end

    context 'when bogus props exist at root and at two nested depths' do
      let(:details) do
        [
          unevaluated_detail(instance_location: '/administrative/accessTemplate', unexpected: %w[unknownLeaf]),
          unevaluated_detail(instance_location: '/administrative/roles/0/members/0', unexpected: %w[unknownLeaf]),
          unevaluated_detail(instance_location: '', unexpected: %w[bogusRoot administrative externalIdentifier label type version]),
          false_schema_detail(instance_location: '/administrative')
        ]
      end

      it 'keeps root and both nested bogus properties' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError) { |error|
          expect(error.message).to include("'bogusRoot'")
          expect(error.message).to include("'unknownLeaf'")
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

  context 'when a filename has a trailing space' do
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
                    filename: 'filename.txt '
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

  describe 'FileAdministrative shelve constraint' do
    let(:clazz) { Cocina::Models::DRO }

    def dro_props(shelve:, sdr_preserve:, publish:) # rubocop:disable Metrics/MethodLength
      {
        externalIdentifier: 'druid:bc123df4567',
        label: 'My item',
        type: Cocina::Models::ObjectType.object,
        version: 1,
        description: {
          title: [{ value: 'Test DRO' }],
          purl: 'https://purl.stanford.edu/bc123df4567'
        },
        administrative: { hasAdminPolicy: 'druid:bc123df4567' },
        access: { view: 'world', download: 'world' },
        identification: { sourceId: 'sul:123' },
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
                    administrative: { shelve: shelve, sdrPreserve: sdr_preserve, publish: publish },
                    hasMessageDigests: [],
                    filename: 'file.txt'
                  }
                ]
              }
            }
          ]
        }
      }
    end

    context 'when shelve=true, sdrPreserve=false, publish=false' do
      let(:props) { dro_props(shelve: true, sdr_preserve: false, publish: false) }

      it 'raises ValidationError' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'when shelve=true, sdrPreserve=true, publish=false' do
      let(:props) { dro_props(shelve: true, sdr_preserve: true, publish: false) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when shelve=true, sdrPreserve=false, publish=true' do
      let(:props) { dro_props(shelve: true, sdr_preserve: false, publish: true) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when shelve=true, sdrPreserve=true, publish=true' do
      let(:props) { dro_props(shelve: true, sdr_preserve: true, publish: true) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when shelve=false, sdrPreserve=false, publish=false' do
      let(:props) { dro_props(shelve: false, sdr_preserve: false, publish: false) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end
  end
end
