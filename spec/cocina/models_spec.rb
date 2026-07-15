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
                                                /When validating .+unexpectedTopLevel.+/)
        end
      end

      context 'when Collection' do
        let(:data) { build(:collection).to_h.merge('unexpectedTopLevel' => 'nope') }

        it 'rejects unknown top-level keys with a helpful message' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                /When validating .+unexpectedTopLevel.+/)
        end
      end

      context 'when AdminPolicy' do
        let(:data) { build(:admin_policy).to_h.merge('unexpectedTopLevel' => 'nope') }

        it 'rejects unknown top-level keys with a helpful message' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                /When validating .+unexpectedTopLevel.+/)
        end
      end

      context 'when DROWithMetadata' do
        let(:data) { build(:dro).to_h.merge('lock' => 'abc123', 'unexpectedTopLevel' => 'nope') }

        it 'rejects unknown top-level keys with a helpful message' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                /When validating .+unexpectedTopLevel.+/)
        end
      end

      context 'when CollectionWithMetadata' do
        let(:data) { build(:collection).to_h.merge('lock' => 'abc123', 'unexpectedTopLevel' => 'nope') }

        it 'rejects unknown top-level keys with a helpful message' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                /When validating .+unexpectedTopLevel.+/)
        end
      end

      context 'when AdminPolicyWithMetadata' do
        let(:data) { build(:admin_policy).to_h.merge('lock' => 'abc123', 'unexpectedTopLevel' => 'nope') }

        it 'rejects unknown top-level keys with a helpful message' do
          expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                /When validating .+unexpectedTopLevel.+/)
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
            /When validating .+unexpectedNested.+/
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
            /When validating .+unexpectedNested.+/
          )
        end
      end

      context 'when DRO has minimally valid relatedResource content' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:description][:relatedResource] = [related_resource]
          end
        end

        context 'with title' do
          let(:related_resource) { { title: [{ value: 'Related title' }] } }

          it 'accepts a minimal title relatedResource shape' do
            expect { model_build }.not_to raise_error
          end
        end

        context 'with contributor' do
          let(:related_resource) { { contributor: [{ name: [{ value: 'Pat Contributor' }] }] } }

          it 'accepts a minimal contributor relatedResource shape' do
            expect { model_build }.not_to raise_error
          end
        end

        context 'with event' do
          let(:related_resource) { { event: [{ note: [{ value: 'Related event' }] }] } }

          it 'accepts a minimal event relatedResource shape' do
            expect { model_build }.not_to raise_error
          end
        end

        context 'with note' do
          let(:related_resource) { { note: [{ value: 'Related note' }] } }

          it 'accepts a minimal note relatedResource shape' do
            expect { model_build }.not_to raise_error
          end
        end

        context 'with identifier' do
          let(:related_resource) { { identifier: [{ value: 'Related identifier' }] } }

          it 'accepts a minimal identifier relatedResource shape' do
            expect { model_build }.not_to raise_error
          end
        end

        context 'with valueAt' do
          let(:related_resource) { { valueAt: 'https://example.com/related' } }

          it 'accepts a minimal valueAt relatedResource shape' do
            expect { model_build }.not_to raise_error
          end
        end

        context 'with purl' do
          let(:related_resource) { { purl: 'https://purl.stanford.edu/bc123df4568' } }

          it 'accepts a minimal purl relatedResource shape' do
            expect { model_build }.not_to raise_error
          end
        end

        context 'with access.url.value' do
          let(:related_resource) { { access: { url: [{ value: 'https://example.com/access' }] } } }

          it 'accepts a minimal access relatedResource shape' do
            expect { model_build }.not_to raise_error
          end
        end

        context 'with access.physicalLocation.value' do
          let(:related_resource) { { access: { physicalLocation: [{ value: 'In a VW Beetle' }] } } }

          it 'accepts a minimal access relatedResource shape' do
            expect { model_build }.not_to raise_error
          end
        end
      end

      context 'when DRO relatedResource has invalid anyOf variants' do
        let(:data) do
          build(:dro).to_h.tap do |h|
            h[:description][:relatedResource] = [related_resource]
          end
        end

        context 'with only a version' do
          let(:related_resource) { { version: '1' } }

          it 'rejects the relatedResource entry' do
            expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                  %r{/description/relatedResource/0 needs to include at least one of the following: title, contributor, event, note, identifier, valueAt, purl, access})
          end
        end

        context 'with empty title array' do
          let(:related_resource) { { title: [] } }

          it 'rejects the relatedResource entry' do
            expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                  %r{/description/relatedResource/0/title is empty but should have at least 1 item; /description/relatedResource/0 needs to include at least one of the following: contributor, event, note, identifier, valueAt, purl, access})
          end
        end

        context 'with empty contributor array' do
          let(:related_resource) { { contributor: [] } }

          it 'rejects the relatedResource entry' do
            expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                  %r{/description/relatedResource/0 needs to include at least one of the following: title, event, note, identifier, valueAt, purl, access; /description/relatedResource/0/contributor is empty but should have at least 1 item})
          end
        end

        context 'with empty event array' do
          let(:related_resource) { { event: [] } }

          it 'rejects the relatedResource entry' do
            expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                  %r{/description/relatedResource/0/event is empty but should have at least 1 item})
          end
        end

        context 'with empty access object' do
          let(:related_resource) { { access: {} } }

          it 'rejects the relatedResource entry' do
            expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                  %r{/description/relatedResource/0/access needs to include at least one of the following: url, physicalLocation, digitalLocation, accessContact, digitalRepository, note; /description/relatedResource/0 needs to include at least one of the following: title, contributor, event, note, identifier, valueAt, purl})
          end
        end

        context 'with empty note array' do
          let(:related_resource) { { note: [] } }

          it 'rejects the relatedResource entry' do
            expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                  %r{/description/relatedResource/0 needs to include at least one of the following: title, contributor, event, identifier, valueAt, purl, access; /description/relatedResource/0/note is empty but should have at least 1 item})
          end
        end

        context 'with empty identifier array' do
          let(:related_resource) { { identifier: [] } }

          it 'rejects the relatedResource entry' do
            expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                  %r{/description/relatedResource/0 needs to include at least one of the following: title, contributor, event, note, valueAt, purl, access; /description/relatedResource/0/identifier is empty but should have at least 1 item})
          end
        end

        context 'with blank valueAt' do
          let(:related_resource) { { valueAt: '' } }

          it 'rejects the relatedResource entry' do
            expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                  %r{is shorter than 1 character at /description/relatedResource/0/valueAt})
          end
        end

        context 'with malformed purl' do
          let(:related_resource) { { purl: 'http://purl.stanford.edu/bc123df4568' } }

          it 'rejects the relatedResource entry' do
            expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                  %r{does not match.*\^https.* at /description/relatedResource/0/purl})
          end
        end

        context 'with empty access url array' do
          let(:related_resource) { { access: { url: [] } } }

          it 'rejects the relatedResource entry' do
            expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                  %r{/description/relatedResource/0/access/url is empty but should have at least 1 item})
          end
        end

        context 'with empty access physicalLocation array' do
          let(:related_resource) { { access: { physicalLocation: [] } } }

          it 'rejects the relatedResource entry' do
            expect { model_build }.to raise_error(Cocina::Models::ValidationError,
                                                  %r{/description/relatedResource/0/access/physicalLocation is empty but should have at least 1 item})
          end
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
            /When validating .+unexpectedNested.+/
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
            /When validating .+unexpectedNested.+/
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

    context 'when label is not provided' do
      context 'with a DRO type' do
        let(:data) { build(:dro).to_h.except(:label) }

        it 'defaults label to empty string' do
          expect(model_build.label).to eq('')
        end
      end

      context 'with a Collection type' do
        let(:data) { build(:collection).to_h.except(:label) }

        it 'defaults label to empty string' do
          expect(model_build.label).to eq('')
        end
      end

      context 'with an AdminPolicy type' do
        let(:data) { build(:admin_policy).to_h.except(:label) }

        it 'defaults label to empty string' do
          expect(model_build.label).to eq('')
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
          'version' => 1,
          'access' => {},
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' },
          'description' => { 'title' => [{ 'value' => 'My collection' }] }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestCollection }
    end

    context 'with a DRO type' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'version' => 1,
          'identification' => {
            'sourceId' => 'sul:123'
          },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' },
          'description' => { 'title' => [{ 'value' => 'My DRO' }] }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestDRO }
    end

    context 'with an AdminPolicy type' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/admin_policy',
          'version' => 1,
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567',
            'hasAgreement' => 'druid:bc123df4567',
            'accessTemplate' => {}
          },
          'description' => { 'title' => [{ 'value' => 'My admin policy' }] }
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
          administrative: { 'hasAdminPolicy' => 'druid:bc123df4567' },
          description: { title: [{ value: 'My DRO' }] }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestDRO }
    end

    context 'with a DRO that has a refreshable catalog link instead of a title' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'version' => 1,
          'identification' => {
            'sourceId' => 'sul:123',
            'catalogLinks' => [
              { 'catalog' => 'folio', 'catalogRecordId' => 'a123', 'refresh' => true }
            ]
          },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestDRO }
    end

    context 'with a Collection that has a refreshable catalog link instead of a title' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/collection',
          'version' => 1,
          'access' => {},
          'identification' => {
            'catalogLinks' => [
              { 'catalog' => 'symphony', 'catalogRecordId' => '123', 'refresh' => true }
            ]
          },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestCollection }
    end

    context 'with both a title and a refreshable catalog link' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'version' => 1,
          'description' => { 'title' => [{ 'value' => 'My DRO' }] },
          'identification' => {
            'sourceId' => 'sul:123',
            'catalogLinks' => [
              { 'catalog' => 'folio', 'catalogRecordId' => 'a123', 'refresh' => true }
            ]
          },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestDRO }
    end

    context 'with a DRO that has neither a title nor catalog links' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'version' => 1,
          'identification' => { 'sourceId' => 'sul:123' },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it 'raises an error' do
        expect { build }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'with a Collection that has neither a title nor catalog links' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/collection',
          'version' => 1,
          'access' => {},
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it 'raises an error' do
        expect { build }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'with an empty catalog links array instead of a title' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'version' => 1,
          'identification' => { 'sourceId' => 'sul:123', 'catalogLinks' => [] },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it 'raises an error' do
        expect { build }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'with only non-refreshable catalog links instead of a title' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/collection',
          'version' => 1,
          'access' => {},
          'identification' => {
            'catalogLinks' => [
              { 'catalog' => 'symphony', 'catalogRecordId' => '123', 'refresh' => false }
            ]
          },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it 'raises an error' do
        expect { build }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'with an empty title and no refreshable catalog link' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'version' => 1,
          'description' => { 'title' => [] },
          'identification' => { 'sourceId' => 'sul:123' },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it 'raises an error' do
        expect { build }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'with an AdminPolicy that has no title' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/admin_policy',
          'version' => 1,
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567',
            'hasAgreement' => 'druid:bc123df4567',
            'accessTemplate' => {}
          }
        }
      end

      it 'raises an error' do
        expect { build }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'with an AdminPolicy that has an empty title' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/admin_policy',
          'version' => 1,
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567',
            'hasAgreement' => 'druid:bc123df4567',
            'accessTemplate' => {}
          },
          'description' => { 'title' => [] }
        }
      end

      it 'raises an error' do
        expect { build }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'with an invalid version' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/book',
          'version' => 5,
          'identification' => {
            'sourceId' => 'sul:123'
          },
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567'
          },
          'description' => { 'title' => [{ 'value' => 'My DRO' }] }
        }
      end

      it 'raises an error' do
        expect do
          build
        end.to raise_error(Cocina::Models::ValidationError,
                           /When validating RequestDRO: 5 is not one of/)
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
