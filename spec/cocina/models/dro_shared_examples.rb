# frozen_string_literal: true

require 'spec_helper'

# These shared_examples are meant to be used by DRO and RequestDRO specs in
# order to de-dup test code for all the functionality they have in common.
# The caller MUST define:
# - required_properties
#    (a hash containing the minimal required properties that must be provided to (Request)DRO.new)
# - struct_class: the class used for the structural attribute (different between DRO and RequestDRO)
# - struct_contains_class: the class used for the members of the contains attribute
#     in the structural attribute (in practice, Cocina::Models::DRO or Cocina::Models::RequestDRO)
RSpec.shared_examples 'it has dro attributes' do
  let(:instance) { described_class.new(properties) }
  let(:item_type) { Cocina::Models::Vocab.object }
  let(:file_set_type) { Cocina::Models::Vocab.fileset }
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
        access = instance.access
        expect(access).to be_kind_of Cocina::Models::DRO::Access
        expect(access.access).to eq 'dark'
        expect(access.copyright).to be_nil
        expect(access.embargo).to be_nil
        expect(access.useAndReproductionStatement).to be_nil

        administrative = instance.administrative
        expect(administrative).to be_kind_of Cocina::Models::DRO::Administrative
        expect(administrative.hasAdminPolicy).to be_nil
        expect(administrative.releaseTags).to eq []

        expect(instance.identification).to be_kind_of Cocina::Models::DRO::Identification
        expect(instance.identification.attributes.size).to eq 0

        expect(instance.structural).to be_kind_of struct_class
        expect(instance.structural.attributes.size).to eq 0
      end
    end

    context 'with all specifiable properties' do
      let(:properties) do
        required_properties.merge(
          access: {
            embargo: {
              releaseDate: '2009-12-14T07:00:00Z',
              access: 'world',
              useAndReproductionStatement: 'These materials are in the public domain.'
            },
            access: 'stanford',
            copyright: 'All rights reserved unless otherwise indicated.',
            useAndReproductionStatement: 'Property rights reside with the repository...'
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
                to: 'Searchworks',
                release: false
              }
            ],
            partOfProject: 'Google Books'
          },
          description: {
            title: [
              {
                primary: true,
                titleFull: 'My object'
              }
            ]
          },
          geographic: {
            iso19139: '<geoXML>here</geoXML>'
          },
          identification: {
            sourceId: 'source:999',
            catalogLinks: [
              { catalog: 'symphony', catalogRecordId: '44444' }
            ]
          },
          structural: {
            hasAgreement: 'druid:666',
            isMemberOf: 'druid:bc777df7777',
            contains: [
              Cocina::Models::FileSet.new(type: file_set_type,
                                          version: 1,
                                          externalIdentifier: '12343234_1',
                                          label: 'Resource #1'),
              Cocina::Models::FileSet.new(type: file_set_type,
                                          version: 2,
                                          externalIdentifier: '12343234_2',
                                          label: 'Resource #2')
            ],
            hasMemberOrders: [
              { viewingDirection: 'right-to-left' }
            ]
          }
        )
      end

      it 'populates all attributes passed in' do
        access = instance.access
        expect(access.access).to eq 'stanford'
        expect(access.copyright).to eq 'All rights reserved unless otherwise indicated.'
        expect(access.useAndReproductionStatement).to eq 'Property rights reside with the repository...'
        embargo = access.embargo
        expect(embargo.releaseDate).to eq DateTime.parse('2009-12-14T07:00:00Z')
        expect(embargo.access).to eq 'world'
        expect(embargo.useAndReproductionStatement).to eq 'These materials are in the public domain.'

        admin = instance.administrative
        expect(admin.hasAdminPolicy).to eq 'druid:mx123cd4567'
        expect(admin.releaseTags).to all(be_kind_of(Cocina::Models::ReleaseTag))
        tag = admin.releaseTags.first
        expect(tag.date).to eq DateTime.parse '2018-11-23T00:44:52Z'
        expect(tag.to).to eq 'Searchworks'
        expect(tag.release).to be true
        expect(admin.partOfProject).to eq('Google Books')

        desc = instance.description
        expect(desc.title).to all(be_kind_of(Cocina::Models::Description::Title))
        expect(desc.title.size).to eq 1
        title = desc.title.first
        expect(title.primary).to be true
        expect(title.titleFull).to eq 'My object'

        expect(instance.geographic.iso19139).to eq '<geoXML>here</geoXML>'

        identification = instance.identification
        expect(identification.sourceId).to eq 'source:999'
        link = identification.catalogLinks.first
        expect(link.catalog).to eq 'symphony'
        expect(link.catalogRecordId).to eq '44444'

        structural = instance.structural
        expect(structural).to be_kind_of struct_class
        expect(structural.hasAgreement).to eq 'druid:666' if struct_class == Cocina::Models::DRO
        expect(structural.isMemberOf).to eq 'druid:bc777df7777'
        contains = structural.contains
        expect(contains).to all(be_kind_of(struct_contains_class))
        expect(contains.size).to eq 2
        fileset1 = contains.first
        expect(fileset1.type).to eq file_set_type
        expect(fileset1.label).to eq 'Resource #1'
        expect(fileset1.version).to eq 1
        fileset2 = contains.last
        expect(fileset2.type).to eq file_set_type
        expect(fileset2.label).to eq 'Resource #2'
        expect(fileset2.version).to eq 2
        if required_properties[:externalIdentifier]
          expect(fileset1.externalIdentifier).to eq '12343234_1'
          expect(fileset2.externalIdentifier).to eq '12343234_2'
        end
        expect(structural.hasMemberOrders.first.viewingDirection).to eq 'right-to-left'
      end
    end

    context 'with empty properties that have default values' do
      let(:properties) do
        required_properties.merge(
          access: {},
          administrative: {},
          identification: {},
          structural: {}
        )
      end

      it 'uses default values' do
        access = instance.access
        expect(access).to be_kind_of Cocina::Models::DRO::Access
        expect(access.access).to eq 'dark'
        expect(access.copyright).to be_nil
        expect(access.embargo).to be_nil
        expect(access.useAndReproductionStatement).to be_nil

        administrative = instance.administrative
        expect(administrative).to be_kind_of Cocina::Models::DRO::Administrative
        expect(administrative.hasAdminPolicy).to be_nil
        expect(administrative.releaseTags).to eq []

        expect(instance.identification).to be_kind_of Cocina::Models::DRO::Identification
        expect(instance.identification.attributes.size).to eq 0

        expect(instance.structural).to be_kind_of struct_class
        expect(instance.structural.attributes.size).to eq 0
      end
    end
  end
end
