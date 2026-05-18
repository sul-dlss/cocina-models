# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models do
  it 'has a version number' do
    expect(Cocina::Models::VERSION).not_to be_nil
  end

  describe '.build' do
    subject(:model_build) { described_class.build(data) }

    context 'with a collection type' do
      let(:data) { build(:collection).to_h }

      it { is_expected.to be_a Cocina::Models::Collection }
    end

    context 'with a DRO type' do
      let(:data) { build(:dro).to_h }

      it { is_expected.to be_a Cocina::Models::DRO }
    end

    context 'with a DRO with metadata' do
      let(:data) { build(:dro_with_metadata).to_h }

      it { is_expected.to be_a Cocina::Models::DROWithMetadata }
    end

    context 'with an AdminPolicy type' do
      let(:data) { build(:admin_policy).to_h }

      it { is_expected.to be_a Cocina::Models::AdminPolicy }
    end

    context 'with keys as strings' do
      let(:data) { build(:dro).to_h.deep_stringify_keys }

      it { is_expected.to be_a Cocina::Models::DRO }
    end

    context 'with an invalid type' do
      let(:data) do
        { 'type' => 'foo' }
      end

      it 'raises an error' do
        expect { model_build }.to raise_error Cocina::Models::UnknownTypeError, "Unknown type: 'foo'"
      end
    end

    context 'without a type' do
      let(:data) do
        {}
      end

      it 'raises an error' do
        expect { model_build }.to raise_error Cocina::Models::ValidationError
      end
    end

    context 'with unexpected properties' do
      context 'when DRO' do
        let(:data) { build(:dro).to_h.merge('unexpectedTopLevel' => 'nope') }

        it 'rejects unknown top-level keys with a helpful message' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                /When validating .+ property .+ is a disallowed unevaluated property/)
        end
      end

      context 'when Collection' do
        let(:data) { build(:collection).to_h.merge('unexpectedTopLevel' => 'nope') }

        it 'rejects unknown top-level keys with a helpful message' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                /When validating .+ property .+ is a disallowed unevaluated property/)
        end
      end

      context 'when AdminPolicy' do
        let(:data) { build(:admin_policy).to_h.merge('unexpectedTopLevel' => 'nope') }

        it 'rejects unknown top-level keys with a helpful message' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                /When validating .+ property .+ is a disallowed unevaluated property/)
        end
      end

      context 'when DROWithMetadata' do
        let(:data) { build(:dro).to_h.merge('lock' => 'abc123', 'unexpectedTopLevel' => 'nope') }

        it 'rejects unknown top-level keys with a helpful message' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                /When validating .+ property .+ is a disallowed unevaluated property/)
        end
      end

      context 'when CollectionWithMetadata' do
        let(:data) { build(:collection).to_h.merge('lock' => 'abc123', 'unexpectedTopLevel' => 'nope') }

        it 'rejects unknown top-level keys with a helpful message' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                /When validating .+ property .+ is a disallowed unevaluated property/)
        end
      end

      context 'when AdminPolicyWithMetadata' do
        let(:data) { build(:admin_policy).to_h.merge('lock' => 'abc123', 'unexpectedTopLevel' => 'nope') }

        it 'rejects unknown top-level keys with a helpful message' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                /When validating .+ property .+ is a disallowed unevaluated property/)
        end
      end

      context 'when DRO has unexpected nested descriptive title property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:description][:title].first[:unexpectedNested] = 'nope'
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(
            Cocina::Models::ValidationError,
            /When validating .+unexpectedNested.+disallowed unevaluated property/
          )
        end
      end

      context 'when DRO has unexpected nested relatedResource property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:description][:relatedResource] = [{ type: 'has part', unexpectedNested: 'nope' }]
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(
            Cocina::Models::ValidationError,
            /When validating .+unexpectedNested.+disallowed unevaluated property/
          )
        end
      end

      context 'when AdminPolicy accessTemplate has unexpected nested property' do
        let(:data) do
          build(:admin_policy).to_h.tap do |h|
            h[:administrative][:accessTemplate] = { view: 'world', download: 'world', unexpectedNested: 'nope' }
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
        end
      end

      context 'when DRO access has unexpected nested property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:access][:unexpectedNested] = 'nope'
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
        end
      end

      context 'when DRO has unexpected nested contributor property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:description][:contributor] = [{ name: [{ value: 'Jane Doe' }], unexpectedNested: 'nope' }]
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(
            Cocina::Models::ValidationError,
            /When validating .+unexpectedNested.+disallowed unevaluated property/
          )
        end
      end

      context 'when DRO has unexpected nested event property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:description][:event] = [{ type: 'creation', unexpectedNested: 'nope' }]
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(
            Cocina::Models::ValidationError,
            /When validating .+unexpectedNested.+disallowed unevaluated property/
          )
        end
      end

      context 'when DRO has unexpected nested property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:description][:language] = [{ value: 'English', unexpectedNested: 'nope' }]
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
        end
      end

      context 'when AdminPolicy role member has unexpected nested property' do
        let(:data) do
          build(:admin_policy).to_h.tap do |h|
            h[:administrative][:roles] = [
              {
                name: 'dor-apo-manager',
                members: [
                  { type: 'sunetid', identifier: 'jdoe', unexpectedNested: 'nope' }
                ]
              }
            ]
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
        end
      end

      context 'when DRO hasMemberOrders entry has unexpected nested property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:structural][:hasMemberOrders] = [
              {
                members: ['druid:bc123df4567'],
                viewingDirection: 'left-to-right',
                unexpectedNested: 'nope'
              }
            ]
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
        end
      end

      context 'when Collection catalogLink has unexpected nested property' do
        let(:data) do
          build(:collection).to_h.tap do |h|
            h[:identification][:catalogLinks] = [
              {
                catalog: 'symphony',
                refresh: false,
                catalogRecordId: '11403803',
                unexpectedNested: 'nope'
              }
            ]
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
        end
      end

      context 'when DRO file administrative has unexpected nested property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:structural][:contains] = [
              {
                type: 'https://cocina.sul.stanford.edu/models/resources/file',
                externalIdentifier: 'https://cocina.sul.stanford.edu/fileSet/1',
                label: 'File Set 1',
                version: 1,
                structural: {
                  contains: [
                    {
                      type: 'https://cocina.sul.stanford.edu/models/file',
                      externalIdentifier: 'https://cocina.sul.stanford.edu/file/1',
                      label: 'file1',
                      filename: 'file1.tif',
                      version: 1,
                      access: { view: 'world', download: 'world' },
                      administrative: {
                        publish: true,
                        sdrPreserve: true,
                        shelve: true,
                        unexpectedNested: 'nope'
                      },
                      hasMessageDigests: [{ type: 'md5', digest: 'abc123' }]
                    }
                  ]
                }
              }
            ]
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
        end
      end

      context 'when DRO message digest has unexpected nested property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:structural][:contains] = [
              {
                type: 'https://cocina.sul.stanford.edu/models/resources/file',
                externalIdentifier: 'https://cocina.sul.stanford.edu/fileSet/1',
                label: 'File Set 1',
                version: 1,
                structural: {
                  contains: [
                    {
                      type: 'https://cocina.sul.stanford.edu/models/file',
                      externalIdentifier: 'https://cocina.sul.stanford.edu/file/1',
                      label: 'file1',
                      filename: '1.tif',
                      version: 1,
                      access: { view: 'world', download: 'world' },
                      administrative: { publish: true, sdrPreserve: true, shelve: true },
                      hasMessageDigests: [{ type: 'md5', digest: 'abc123', unexpectedNested: 'nope' }]
                    }
                  ]
                }
              }
            ]
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
        end
      end

      context 'when DRO administrative has unexpected nested property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:administrative][:unexpectedNested] = 'nope'
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
        end
      end

      context 'when DRO structural has unexpected nested property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:structural][:unexpectedNested] = 'nope'
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
        end
      end

      context 'when DRO geographic has unexpected nested property' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:geographic] = { iso19139: '<xml/>', unexpectedNested: 'nope' }
          end
        end

        it 'rejects unknown nested keys' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
        end
      end
    end
  end

  describe '.build_request' do
    subject(:build) { described_class.build_request(data) }

    context 'with a collection type' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/exhibit',
          'label' => 'bar',
          'version' => 1,
          'access' => {},
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestCollection }
    end

    context 'with a DRO type' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'label' => 'bar',
          'version' => 1,
          'identification' => {
            'sourceId' => 'sul:123'
          },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestDRO }
    end

    context 'with an AdminPolicy type' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/admin_policy',
          'label' => 'bar',
          'version' => 1,
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567',
            'hasAgreement' => 'druid:bc123df4567',
            'accessTemplate' => {}
          }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestAdminPolicy }
    end

    context 'with keys as symbols' do
      let(:data) do
        {
          type: 'https://cocina.sul.stanford.edu/models/image',
          label: 'bar',
          version: 1,
          identification: {
            sourceId: 'sul:123'
          },
          administrative: { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestDRO }
    end

    context 'with an invalid version' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/book',
          'label' => 'bar',
          'version' => 5,
          'identification' => {
            'sourceId' => 'sul:123'
          },
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567'
          }
        }
      end

      it 'raises an error' do
        expect do
          build
        end.to raise_error(Cocina::Models::ValidationError,
                           'When validating RequestDRO: value at `/version` is not one of: [1]')
      end
    end

    context 'with an invalid type' do
      let(:data) do
        { 'type' => 'foo' }
      end

      it 'raises an error' do
        expect { build }.to raise_error(Cocina::Models::UnknownTypeError, "Unknown type: 'foo'")
      end
    end

    context 'without a type' do
      let(:data) do
        {}
      end

      it 'raises an error' do
        expect { build }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'when RequestDRO description.title has unexpected property' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'label' => 'bar',
          'version' => 1,
          'identification' => { 'sourceId' => 'sul:123' },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' },
          'description' => {
            'title' => [{ 'value' => 'My title', 'unexpectedNested' => 'nope' }]
          }
        }
      end

      it 'rejects unknown nested keys' do
        expect { build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
      end
    end

    context 'when RequestDRO administrative has unexpected property' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'label' => 'bar',
          'version' => 1,
          'identification' => { 'sourceId' => 'sul:123' },
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567',
            'unexpectedNested' => 'nope'
          }
        }
      end

      it 'rejects unknown nested keys' do
        expect { build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
      end
    end

    context 'when RequestDRO structural has unexpected property' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'label' => 'bar',
          'version' => 1,
          'identification' => { 'sourceId' => 'sul:123' },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' },
          'structural' => { 'unexpectedNested' => 'nope' }
        }
      end

      it 'rejects unknown nested keys' do
        expect { build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
      end
    end

    context 'when RequestCollection access has unexpected property' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/exhibit',
          'label' => 'bar',
          'version' => 1,
          'access' => { 'view' => 'world', 'unexpectedNested' => 'nope' },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it 'rejects unknown nested keys' do
        expect { build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
      end
    end

    context 'when RequestCollection identification has unexpected property' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/exhibit',
          'label' => 'bar',
          'version' => 1,
          'access' => {},
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' },
          'identification' => { 'sourceId' => 'sul:123', 'unexpectedNested' => 'nope' }
        }
      end

      it 'rejects unknown nested keys' do
        expect { build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
      end
    end

    context 'when RequestAdminPolicy administrative has unexpected property' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/admin_policy',
          'label' => 'bar',
          'version' => 1,
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567',
            'hasAgreement' => 'druid:bc123df4567',
            'accessTemplate' => {},
            'unexpectedNested' => 'nope'
          }
        }
      end

      it 'rejects unknown nested keys' do
        expect { build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
      end
    end

    context 'when RequestAdminPolicy accessTemplate has unexpected property' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/admin_policy',
          'label' => 'bar',
          'version' => 1,
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567',
            'hasAgreement' => 'druid:bc123df4567',
            'accessTemplate' => { 'view' => 'world', 'download' => 'world', 'unexpectedNested' => 'nope' }
          }
        }
      end

      it 'rejects unknown nested keys' do
        expect { build }.to raise_error(Cocina::Models::ValidationError, /unexpectedNested/)
      end
    end
  end

  describe '.build_lite' do
    subject(:model_build) { described_class.build_lite(data) }

    context 'with a collection type' do
      let(:data) { build(:collection).to_h }

      it { is_expected.to be_a Cocina::Models::CollectionLite }
    end

    context 'with a DRO type' do
      let(:data) { build(:dro).to_h }

      it { is_expected.to be_a Cocina::Models::DROLite }
    end

    context 'with an AdminPolicy type' do
      let(:data) { build(:admin_policy).to_h }

      it { is_expected.to be_a Cocina::Models::AdminPolicyLite }
    end

    context 'with extra fields' do
      let(:data) do
        data = build(:dro).to_h
        data[:extra] = 'field'
        data
      end

      it { is_expected.to be_a Cocina::Models::DROLite }
    end

    context 'with keys as strings' do
      let(:data) { build(:dro).to_h.deep_stringify_keys }

      it { is_expected.to be_a Cocina::Models::DROLite }
    end

    context 'with an invalid type' do
      let(:data) do
        { 'type' => 'foo' }
      end

      it 'raises an error' do
        expect { model_build }.to raise_error Cocina::Models::UnknownTypeError, "Unknown type: 'foo'"
      end
    end

    context 'without a type' do
      let(:data) do
        {}
      end

      it 'raises an error' do
        expect { model_build }.to raise_error Cocina::Models::ValidationError
      end
    end
  end

  describe '.without_metadata' do
    subject(:cocina_object_without_metadata) { described_class.without_metadata(cocina_object) }

    let(:cocina_object) { build(:dro_with_metadata) }

    it { is_expected.to be_a Cocina::Models::DRO }
  end

  describe '.with_metadata' do
    subject(:cocina_object_with_metadata) do
      described_class.with_metadata(cocina_object, 'abc123', created: date, modified: date)
    end

    let(:date) { DateTime.now }

    let(:cocina_object) { build(:dro) }

    let(:props) { cocina_object.to_h }

    let(:expected) do
      Cocina::Models::DROWithMetadata.new(props.merge({ lock: 'abc123', created: date.to_s, modified: date.to_s }))
    end

    it 'returns a DROWithMetadata' do
      expect(cocina_object_with_metadata).to be_a Cocina::Models::DROWithMetadata
      expect(cocina_object_with_metadata).to match_cocina_object_with(expected.to_h)
    end
  end

  describe '.with_metadata for Collection' do
    subject(:cocina_object_with_metadata) do
      described_class.with_metadata(cocina_object, 'abc123', created: date, modified: date)
    end

    let(:date) { DateTime.now }
    let(:cocina_object) { build(:collection) }
    let(:props) { cocina_object.to_h }

    let(:expected) do
      Cocina::Models::CollectionWithMetadata.new(
        props.merge({ lock: 'abc123', created: date.iso8601, modified: date.iso8601 })
      )
    end

    it 'returns a CollectionWithMetadata' do
      expect(cocina_object_with_metadata).to be_a(Cocina::Models::CollectionWithMetadata)
      expect(cocina_object_with_metadata).to match_cocina_object_with(expected.to_h)
    end
  end

  describe '.with_metadata for AdminPolicy' do
    subject(:cocina_object_with_metadata) do
      described_class.with_metadata(cocina_object, 'abc123', created: date, modified: date)
    end

    let(:date) { DateTime.now }
    let(:cocina_object) { build(:admin_policy) }
    let(:props) { cocina_object.to_h }

    let(:expected) do
      Cocina::Models::AdminPolicyWithMetadata.new(
        props.merge({ lock: 'abc123', created: date.iso8601, modified: date.iso8601 })
      )
    end

    it 'returns an AdminPolicyWithMetadata' do
      expect(cocina_object_with_metadata).to be_a(Cocina::Models::AdminPolicyWithMetadata)
      expect(cocina_object_with_metadata).to match_cocina_object_with(expected.to_h)
    end
  end
end
