# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Collection do
  subject(:collection) { described_class.new(properties) }

  let(:collection_type) { Cocina::Models::Vocab.collection }
  let(:properties) do
    {
      externalIdentifier: 'druid:ab123cd4567',
      type: collection_type,
      label: 'My collection',
      version: 3,
      description: {
        title: []
      }
    }
  end

  describe 'model check methods' do
    it { is_expected.not_to be_admin_policy }
    it { is_expected.to be_collection }
    it { is_expected.not_to be_dro }
    it { is_expected.not_to be_file }
    it { is_expected.not_to be_file_set }
  end

  describe Cocina::Models::Collection::Administrative do
    let(:instance) { described_class.new }

    describe '#releaseTags' do
      subject { instance.releaseTags }

      it { is_expected.to be_empty }
    end
  end

  describe 'initialization' do
    context 'with a minimal set, defined above' do
      it 'has properties' do
        expect(collection.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(collection.type).to eq collection_type
        expect(collection.label).to eq 'My collection'

        expect(collection.access).to be_kind_of Cocina::Models::Collection::Access
      end
    end

    context 'with a string version' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: collection_type,
          label: 'My collection',
          version: '3',
          description: {
            title: []
          }
        }
      end

      it 'coerces to integer' do
        expect(collection.version).to eq 3
      end
    end

    context 'with a all properties' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: collection_type,
          label: 'My collection',
          version: 3,
          access: {
            access: 'stanford'
          },
          administrative: {
            hasAdminPolicy: 'druid:mx123cd4567',
            releaseTags: [
              {
                who: 'Justin',
                what: 'collection',
                date: '2018-11-23T00:44:52Z',
                to: 'Searchworks',
                release: 'true'
              },
              {
                who: 'Other Justin',
                what: 'self',
                date: '2017-10-20T15:42:15Z',
                to: 'Earthworks',
                release: 'false'
              }
            ]
          },
          description: {
            title: [
              {
                primary: true,
                titleFull: 'My collection'
              }
            ]
          },
          identification: {
            agreementId: 'druid:666',
            sourceId: 'source:999',
            catalogLinks: [
              { catalog: 'symphony', catalogRecordId: '44444' }
            ]
          }
        }
      end

      it 'has properties' do
        expect(collection.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(collection.type).to eq collection_type
        expect(collection.label).to eq 'My collection'

        expect(collection.access.access).to eq 'stanford'

        expect(collection.administrative.hasAdminPolicy).to eq 'druid:mx123cd4567'
        expect(collection.administrative.releaseTags).to all(be_kind_of(Cocina::Models::ReleaseTag))
        tag = collection.administrative.releaseTags.first
        expect(tag.date).to eq DateTime.parse '2018-11-23T00:44:52Z'
        expect(tag.to).to eq 'Searchworks'
        expect(tag.release).to be true

        expect(collection.identification.agreementId).to eq 'druid:666'

        link = collection.identification.catalogLinks.first
        expect(link.catalog).to eq 'symphony'
        expect(link.catalogRecordId).to eq '44444'
      end
    end
  end

  describe '.from_dynamic' do
    subject(:collection) { described_class.from_dynamic(properties) }

    context 'with empty subschemas' do
      let(:properties) do
        {
          'externalIdentifier' => 'druid:kv840rx2720',
          'type' => collection_type,
          'label' => 'Examination of the memorial of the owners and underwriters ...',
          'version' => 1,
          'access' => {},
          'administrative' => {},
          'description' => {
            'title' => []
          },
          'identification' => {},
          'structural' => {}
        }
      end

      it 'has properties' do
        expect(collection.externalIdentifier).to eq 'druid:kv840rx2720'
      end
    end
  end

  describe '.from_json' do
    subject(:collection) { described_class.from_json(json) }

    context 'with a minimal collection' do
      let(:json) do
        <<~JSON
          {
            "externalIdentifier":"druid:12343234",
            "type":"#{collection_type}",
            "label":"my collection",
            "version": 3,
            "description": {
              "title": []
            }
          }
        JSON
      end

      it 'has the attributes' do
        expect(collection.attributes).to include(externalIdentifier: 'druid:12343234',
                                                 label: 'my collection',
                                                 type: collection_type)
        expect(collection.access).to be_kind_of Cocina::Models::Collection::Access
        expect(collection.administrative).to be_kind_of Cocina::Models::Collection::Administrative
        expect(collection.identification).to be_kind_of Cocina::Models::Collection::Identification
        expect(collection.structural).to be_kind_of Cocina::Models::Collection::Structural
      end
    end

    context 'with a full collection' do
      let(:json) do
        <<~JSON
          {
            "externalIdentifier":"druid:12343234",
            "type":"#{collection_type}",
            "label":"my collection",
            "version": 3,
            "access": {
              "access": "world"
            },
            "administrative": {
              "hasAdminPolicy":"druid:mx123cd4567",
              "releaseTags": [
                {
                  "who":"Justin",
                  "what":"collection",
                  "date":"2018-11-23T00:44:52Z",
                  "to":"Searchworks",
                  "release":true
                },
                {
                  "who":"Other Justin",
                  "what":"self",
                  "date":"2017-10-20T15:42:15Z",
                  "to":"Searchworks",
                  "release":false
                }
              ]
            },
            "description": {
              "title": [
                {
                  "primary": true,
                  "titleFull":"my collection"
                }
              ]
            },
            "identification": {
              "catalogLinks":[
                {
                  "catalog":"symphony",
                  "catalogRecordId":"44444"
                }
              ]
            }
          }
        JSON
      end

      it 'has the attributes' do
        expect(collection.attributes).to include(externalIdentifier: 'druid:12343234',
                                                 label: 'my collection',
                                                 type: collection_type)
        expect(collection.access.access).to eq 'world'

        expect(collection.administrative.hasAdminPolicy).to eq 'druid:mx123cd4567'

        tags = collection.administrative.releaseTags
        expect(tags).to all(be_instance_of Cocina::Models::ReleaseTag)

        expect(collection.description.title.first.attributes).to eq(primary: true,
                                                                    titleFull: 'my collection')

        link = collection.identification.catalogLinks.first
        expect(link.catalog).to eq 'symphony'
        expect(link.catalogRecordId).to eq '44444'
      end
    end
  end
end
