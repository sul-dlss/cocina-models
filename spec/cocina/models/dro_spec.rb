# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::DRO do
  subject(:item) { described_class.new(properties) }

  let(:item_type) { Cocina::Models::Vocab.object }
  let(:fileset_type) { Cocina::Models::Vocab.fileset }

  let(:properties) do
    {
      externalIdentifier: 'druid:ab123cd4567',
      type: item_type,
      label: 'My object',
      version: 3,
      description: {
        title: []
      }
    }
  end

  describe 'model check methods' do
    it { is_expected.not_to be_admin_policy }
    it { is_expected.not_to be_collection }
    it { is_expected.to be_dro }
    it { is_expected.not_to be_file }
    it { is_expected.not_to be_file_set }
  end

  describe Cocina::Models::DRO::Administrative do
    let(:instance) { described_class.new }

    describe '#releaseTags' do
      subject { instance.releaseTags }

      it { is_expected.to be_empty }
    end
  end

  describe 'initialization' do
    context 'with a minimal set, as defined above' do
      it 'has properties' do
        expect(item.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(item.type).to eq item_type
        expect(item.label).to eq 'My object'

        expect(item.access).to be_kind_of Cocina::Models::DRO::Access
      end
    end

    context 'with a string version' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: item_type,
          label: 'My object',
          version: '3',
          description: {
            title: []
          }
        }
      end

      it 'coerces to integer' do
        expect(item.version).to eq 3
      end
    end

    context 'with a all properties' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: item_type,
          label: 'My object',
          version: 3,
          access: {
            embargo: {
              releaseDate: '2009-12-14T07:00:00Z',
              access: 'world'
            },
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
                to: 'Searchworks',
                release: 'false'
              }
            ]
          },
          description: {
            title: [
              {
                primary: true,
                titleFull: 'My object'
              }
            ]
          },
          identification: {
            agreementId: 'druid:666',
            sourceId: 'source:999',
            catalogLinks: [
              { catalog: 'symphony', catalogRecordId: '44444' }
            ]
          },
          structural: {
            isMemberOf: 'druid:bc777df7777',
            contains: [
              Cocina::Models::FileSet.new(type: fileset_type,
                                          version: 3,
                                          externalIdentifier: '12343234_1', label: 'Resource #1'),
              Cocina::Models::FileSet.new(type: fileset_type,
                                          version: 3,
                                          externalIdentifier: '12343234_2', label: 'Resource #2')
            ],
            hasMemberOrders: [
              { viewingDirection: 'right-to-left' }
            ]
          }
        }
      end

      it 'has properties' do
        expect(item.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(item.type).to eq item_type
        expect(item.label).to eq 'My object'

        expect(item.access.access).to eq 'stanford'
        expect(item.access.embargo.releaseDate).to eq DateTime.parse('2009-12-14T07:00:00Z')
        expect(item.access.embargo.access).to eq 'world'

        expect(item.administrative.hasAdminPolicy).to eq 'druid:mx123cd4567'
        expect(item.administrative.releaseTags).to all(be_kind_of(Cocina::Models::ReleaseTag))
        tag = item.administrative.releaseTags.first
        expect(tag.date).to eq DateTime.parse '2018-11-23T00:44:52Z'
        expect(tag.to).to eq 'Searchworks'
        expect(tag.release).to be true

        expect(item.identification.agreementId).to eq 'druid:666'
        expect(item.identification.sourceId).to eq 'source:999'
        link = item.identification.catalogLinks.first
        expect(link.catalog).to eq 'symphony'
        expect(link.catalogRecordId).to eq '44444'

        expect(item.structural.contains).to all(be_instance_of(Cocina::Models::FileSet))
        expect(item.structural.isMemberOf).to eq 'druid:bc777df7777'
        expect(item.structural.hasMemberOrders.first.viewingDirection).to eq 'right-to-left'
      end
    end
  end

  describe '.from_dynamic' do
    subject(:item) { described_class.from_dynamic(properties) }

    context 'with empty subschemas' do
      let(:properties) do
        {
          'externalIdentifier' => 'druid:kv840rx2720',
          'type' => item_type,
          'label' => 'Examination of the memorial of the owners and underwriters ...',
          'version' => 1,
          'access' => {},
          'administrative' => { 'releaseTags' => [] },
          'description' => {
            'title' => []
          },
          'identification' => {},
          'structural' => {}
        }
      end

      it 'has properties' do
        expect(item.externalIdentifier).to eq 'druid:kv840rx2720'
      end
    end
  end

  describe '.from_json' do
    subject(:dro) { described_class.from_json(json) }

    context 'with a minimal object' do
      let(:json) do
        <<~JSON
          {
            "externalIdentifier":"druid:12343234",
            "type":"#{item_type}",
            "label":"my item",
            "version": 3,
            "description": {
              "title": []
            }
          }
        JSON
      end

      it 'has the attributes' do
        expect(dro.attributes).to include(externalIdentifier: 'druid:12343234',
                                          label: 'my item',
                                          type: item_type)
        expect(dro.access).to be_kind_of Cocina::Models::DRO::Access
        expect(dro.administrative).to be_kind_of Cocina::Models::DRO::Administrative
        expect(dro.identification).to be_kind_of Cocina::Models::DRO::Identification
        expect(dro.structural).to be_kind_of Cocina::Models::DRO::Structural
      end
    end

    context 'with a full object' do
      let(:json) do
        <<~JSON
          {
            "externalIdentifier":"druid:12343234",
            "type":"#{item_type}",
            "label":"my item",
            "version": 3,
            "access": {
              "access": "dark",
              "embargo": {
                "releaseDate":"2009-12-14T07:00:00Z"
              }
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
                  "titleFull":"my object"
                }
              ]
            },
            "identification": {
              "sourceId":"source:9999",
              "catalogLinks":[
                {
                  "catalog":"symphony",
                  "catalogRecordId":"44444"
                }
              ]
            },
            "structural": {
              "contains": [
                {
                  "type":"#{fileset_type}",
                  "version":3,
                  "externalIdentifier":"12343234_1", "label":"Resource #1"
                },
                {
                  "type":"#{fileset_type}",
                  "version":3,
                  "externalIdentifier":"12343234_2", "label":"fileset#2"
                }
              ],
              "isMemberOf":"druid:bc777df7777",
              "hasMemberOrders":[
                { "viewingDirection":"left-to-right"}
              ]
            }
          }
        JSON
      end

      it 'has the attributes' do
        expect(dro.attributes).to include(externalIdentifier: 'druid:12343234',
                                          label: 'my item',
                                          type: item_type)

        expect(dro.access.access).to eq 'dark'

        embargo_attributes = dro.access.embargo.attributes
        expect(embargo_attributes).to eq(releaseDate: DateTime.parse('2009-12-14T07:00:00Z'), access: 'dark')

        expect(dro.administrative.hasAdminPolicy).to eq 'druid:mx123cd4567'

        tags = dro.administrative.releaseTags
        expect(tags).to all(be_instance_of Cocina::Models::ReleaseTag)

        expect(dro.identification.sourceId).to eq 'source:9999'
        link = dro.identification.catalogLinks.first
        expect(link.catalog).to eq 'symphony'
        expect(link.catalogRecordId).to eq '44444'

        expect(dro.structural.contains).to all(be_instance_of(Cocina::Models::FileSet))
        expect(dro.structural.isMemberOf).to eq 'druid:bc777df7777'
        expect(dro.structural.hasMemberOrders.first.viewingDirection).to eq 'left-to-right'
        expect(dro.description.title.first.attributes).to eq(primary: true,
                                                             titleFull: 'my object')
      end
    end
  end

  describe '.image?' do
    subject(:item) { described_class.new(properties) }

    let(:properties) do
      {
        externalIdentifier: 'druid:ab123cd4567',
        type: item_type,
        label: 'My object',
        version: 3,
        description: {
          title: []
        }
      }
    end

    it { is_expected.not_to be_image }

    context 'when it has the image type' do
      let(:item_type) { 'http://cocina.sul.stanford.edu/models/image.jsonld' }

      it { is_expected.to be_image }
    end
  end
end
