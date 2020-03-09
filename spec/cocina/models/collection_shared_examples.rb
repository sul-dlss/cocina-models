# frozen_string_literal: true

require 'spec_helper'

# These shared_examples are meant to be used by Collection and RequestCollection specs in
# order to de-dup test code for all the functionality they have in common.
# The caller must define required_properties as a hash containing
#   the minimal required properties that must be provided to (Request)Collection.new
RSpec.shared_examples 'it has collection attributes' do
  let(:instance) { described_class.new(properties) }
  let(:collection_type) { Cocina::Models::Vocab.collection }
  # see block comment for info about required_properties
  let(:properties) { required_properties }

  describe 'initialization' do
    context 'with minimal required properties provided' do
      it 'populates required attributes passed in' do
        if required_properties[:externalIdentifier]
          expect(instance.externalIdentifier).to eq required_properties[:externalIdentifier]
        end
        expect(instance.label).to eq required_properties[:label]
        expect(instance.type).to eq required_properties[:type]
        expect(instance.version).to eq required_properties[:version]
      end

      it 'populates non-passed required attributes with default values' do
        expect(instance.access).to be_kind_of(Cocina::Models::Collection::Access)
        expect(instance.access.access).to eq 'dark'

        expect(instance.administrative).to be_kind_of(Cocina::Models::Collection::Administrative)
        expect(instance.administrative.releaseTags).to eq []
        expect(instance.administrative.hasAdminPolicy).to be_nil

        expect(instance.identification).to be_kind_of(Cocina::Models::Collection::Identification)
        expect(instance.identification.catalogLinks).to be_nil

        expect(instance.structural).to be_kind_of(Cocina::Models::Collection::Structural)
        expect(instance.structural.attributes.size).to eq 0
      end
    end

    context 'with a string version property' do
      let(:properties) { required_properties.merge(version: required_properties[:version].to_s) }

      it 'coerces to integer' do
        expect(instance.version).to eq required_properties[:version]
      end
    end

    context 'with all specifiable properties' do
      let(:properties) do
        required_properties.merge(
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
                release: true
              },
              {
                who: 'Other Justin',
                what: 'self',
                date: '2017-10-20T15:42:15Z',
                to: 'Earthworks',
                release: false
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
            sourceId: 'source:999', # NOTE: not in Collection::Identification
            catalogLinks: [
              { catalog: 'symphony', catalogRecordId: '44444' }
            ]
          }
        )
      end

      it 'populates all attributes passed in' do
        expect(instance.access.access).to eq 'stanford'

        expect(instance.administrative.hasAdminPolicy).to eq 'druid:mx123cd4567'
        expect(instance.administrative.releaseTags).to all(be_kind_of(Cocina::Models::ReleaseTag))
        expect(instance.administrative.releaseTags.size).to eq 2
        tag = instance.administrative.releaseTags.first
        expect(tag.date).to eq DateTime.parse '2018-11-23T00:44:52Z'
        expect(tag.to).to eq 'Searchworks'
        expect(tag.release).to be true

        expect(instance.description.title.first.attributes).to eq(primary: true,
                                                                  titleFull: 'My collection')

        link = instance.identification.catalogLinks.first
        expect(link.catalog).to eq 'symphony'
        expect(link.catalogRecordId).to eq '44444'
      end
    end

    context 'with empty properties that have default values' do
      let(:properties) do
        required_properties.merge(
          access: {},
          administrative: nil,
          identification: nil,
          structural: {}
        )
      end

      it 'uses default values' do
        expect(instance.access).to be_kind_of(Cocina::Models::Collection::Access)
        expect(instance.access.access).to eq 'dark'

        expect(instance.administrative).to be_kind_of(Cocina::Models::Collection::Administrative)
        expect(instance.administrative.releaseTags).to eq []
        expect(instance.administrative.hasAdminPolicy).to be_nil

        expect(instance.identification).to be_kind_of(Cocina::Models::Collection::Identification)
        expect(instance.identification.catalogLinks).to be_nil

        expect(instance.structural).to be_kind_of(Cocina::Models::Collection::Structural)
        expect(instance.structural.attributes.size).to eq 0
      end
    end
  end

  describe '.from_dynamic' do
    let(:instance) { described_class.from_dynamic(properties) }

    context 'with empty subschemas' do
      let(:properties) do
        required_properties.merge(
          'access' => {},
          'administrative' => {},
          'description' => {
            'title' => []
          },
          'identification' => {},
          'structural' => {}
        )
      end

      it 'populates required attributes passed in' do
        if required_properties[:externalIdentifier]
          expect(instance.externalIdentifier).to eq required_properties[:externalIdentifier]
        end
        expect(instance.label).to eq required_properties[:label]
        expect(instance.type).to eq required_properties[:type]
        expect(instance.version).to eq required_properties[:version]
      end

      it 'populates attribute subschemas with default values' do
        expect(instance.access).to be_kind_of(Cocina::Models::Collection::Access)
        expect(instance.access.access).to eq 'dark'

        expect(instance.administrative).to be_kind_of(Cocina::Models::Collection::Administrative)
        expect(instance.administrative.releaseTags).to eq []
        expect(instance.administrative.hasAdminPolicy).to be_nil

        expect(instance.description).to be_kind_of(Cocina::Models::Description)
        expect(instance.description.attributes.size).to eq 1
        expect(instance.description.title).to be_kind_of(Array)
        expect(instance.description.title.size).to eq 0

        expect(instance.identification).to be_kind_of(Cocina::Models::Collection::Identification)
        expect(instance.identification.catalogLinks).to be_nil

        expect(instance.structural).to be_kind_of(Cocina::Models::Collection::Structural)
        expect(instance.structural.attributes.size).to eq 0
      end
    end
  end

  describe '.from_json' do
    let(:instance) { described_class.from_json(json) }

    context 'with minimal required properties' do
      let(:json) { required_properties.to_json }

      it 'populates required attributes passed in' do
        if required_properties[:externalIdentifier]
          expect(instance.externalIdentifier).to eq required_properties[:externalIdentifier]
        end
        expect(instance.label).to eq required_properties[:label]
        expect(instance.type).to eq required_properties[:type]
        expect(instance.version).to eq required_properties[:version]
      end

      it 'populates non-passed required attributes with default values' do
        expect(instance.access).to be_kind_of(Cocina::Models::Collection::Access)
        expect(instance.access.access).to eq 'dark'

        expect(instance.administrative).to be_kind_of(Cocina::Models::Collection::Administrative)
        expect(instance.administrative.releaseTags).to eq []
        expect(instance.administrative.hasAdminPolicy).to be_nil

        expect(instance.identification).to be_kind_of(Cocina::Models::Collection::Identification)
        expect(instance.identification.catalogLinks).to be_nil

        expect(instance.structural).to be_kind_of(Cocina::Models::Collection::Structural)
        expect(instance.structural.attributes.size).to eq 0
      end
    end

    context 'with all specifiable properties' do
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

      it 'populates attributes passed in as expected' do
        expect(instance.attributes).to include(label: 'my collection',
                                               type: collection_type,
                                               version: 3)

        expect(instance.externalIdentifier).to eq 'druid:12343234' if required_properties[:externalIdentifier]

        expect(instance.access.access).to eq 'world'

        expect(instance.administrative.hasAdminPolicy).to eq 'druid:mx123cd4567'

        tags = instance.administrative.releaseTags
        expect(tags).to all(be_instance_of(Cocina::Models::ReleaseTag))

        expect(instance.description.title.first.attributes).to eq(primary: true,
                                                                  titleFull: 'my collection')

        link = instance.identification.catalogLinks.first
        expect(link.catalog).to eq 'symphony'
        expect(link.catalogRecordId).to eq '44444'
      end
    end
  end
end
