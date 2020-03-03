# frozen_string_literal: true

require 'spec_helper'

# These shared_examples are meant to be used by File and RequestFile specs in
# order to de-dup test code for all the functionality they have in common.
# The caller must define required_properties as a hash containing
#   the minimal required properties that must be provided to (Request)File.new
RSpec.shared_examples 'it has file attributes' do
  let(:item) { described_class.new(properties) }
  let(:file_type) { 'http://cocina.sul.stanford.edu/models/file.jsonld' }
  # see block comment for info about required_properties
  let(:properties) { required_properties }

  describe 'initialization' do
    context 'with minimal required properties provided' do
      it 'populates required attributes passed in' do
        if required_properties[:externalIdentifier]
          expect(item.externalIdentifier).to eq required_properties[:externalIdentifier]
        end
        expect(item.label).to eq required_properties[:label]
        expect(item.type).to eq required_properties[:type]
        expect(item.version).to eq required_properties[:version]
      end

      it 'populates non-passed required attributes with default values' do
        expect(item.administrative).to be_kind_of(Cocina::Models::File::Administrative)
        expect(item.administrative.shelve).to be false
        expect(item.administrative.sdrPreserve).to be false

        expect(item.hasMessageDigests).to eq []
      end
    end

    context 'with a string version property' do
      let(:properties) { required_properties.merge(version: required_properties[:version].to_s) }

      it 'coerces to integer' do
        expect(item.version).to eq required_properties[:version]
      end
    end

    context 'with all optional properties provided' do
      let(:properties) do
        required_properties.merge(
          access: {
            access: 'citation-only'
          },
          administrative: {
            shelve: true,
            sdrPreserve: true
          },
          filename: 'filename!!',
          hasMessageDigests: [
            {
              type: 'md5',
              digest: 'd57db4241d7da0eecba5b33abf13f448'
            },
            {
              type: 'sha1',
              digest: '600a43324ea40ae1ba0c7ffa83965830d384c086'
            }
          ],
          hasMimeType: 'image/jp2',
          presentation: { height: 5, width: 8 },
          size: 666,
          structural: {},
          use: 'transcription'
        )
      end

      it 'populates all optional attributes passed in' do
        expect(item.access).to be_kind_of(Cocina::Models::File::Access)
        expect(item.access.access).to eq 'citation-only'

        expect(item.administrative).to be_kind_of(Cocina::Models::File::Administrative)
        expect(item.administrative.shelve).to be true
        expect(item.administrative.sdrPreserve).to be true

        expect(item.filename).to eq 'filename!!'

        expect(item.hasMessageDigests).to be_kind_of(Array)
        expect(item.hasMessageDigests).to all(be_kind_of(Cocina::Models::File::Fixity))
        fixity = item.hasMessageDigests.first
        expect(fixity.type).to eq 'md5'
        expect(fixity.digest).to eq 'd57db4241d7da0eecba5b33abf13f448'

        expect(item.hasMimeType).to eq 'image/jp2'

        expect(item.presentation).to be_kind_of(Cocina::Models::File::Presentation)
        expect(item.presentation.height).to eq 5
        expect(item.presentation.width).to eq 8

        expect(item.size).to eq 666
        expect(item.use).to eq 'transcription'
      end

      context 'with a string administrative boolean property' do
        let(:properties) do
          {
            administrative: {
              shelve: 'true',
              sdrPreserve: 'false'
            },
            externalIdentifier: 'druid:ab123cd4567',
            label: 'My file',
            type: file_type,
            version: '3'
          }
        end

        it 'coerces to boolean' do
          expect(item.administrative).to be_kind_of(Cocina::Models::File::Administrative)
          expect(item.administrative.shelve).to be true
          expect(item.administrative.sdrPreserve).to be false
        end
      end
    end

    context 'with empty optional properties that have default values' do
      let(:properties) do
        required_properties.merge(
          access: {},
          filename: nil,
          hasMessageDigests: [],
          size: nil
        )
      end

      it 'uses default values' do
        expect(item.access).to be_kind_of(Cocina::Models::File::Access)
        expect(item.access.access).to eq 'dark'

        expect(item.filename).to eq nil
        expect(item.hasMessageDigests).to eq []
        expect(item.size).to eq nil
      end
    end
  end

  describe '.from_dynamic' do
    let(:item) { described_class.from_dynamic(properties) }

    context 'with empty subschemas' do
      let(:properties) do
        required_properties.merge(
          'access' => {},
          'identification' => {},
          'structural' => {}
        )
      end

      it 'populates required attributes passed in' do
        if required_properties[:externalIdentifier]
          expect(item.externalIdentifier).to eq required_properties[:externalIdentifier]
        end
        expect(item.label).to eq required_properties[:label]
        expect(item.type).to eq required_properties[:type]
        expect(item.version).to eq required_properties[:version]
      end

      it 'populates non-passed required attributes with default values' do
        expect(item.administrative).to be_kind_of(Cocina::Models::File::Administrative)
        expect(item.administrative.shelve).to be false
        expect(item.administrative.sdrPreserve).to be false

        expect(item.hasMessageDigests).to eq []
      end

      it 'populates optional attributes that have defaults' do
        expect(item.access).to be_kind_of(Cocina::Models::File::Access)
        expect(item.access.access).to eq 'dark'
      end

      it 'has a class responding to Dry::Struct methods for empty subschemas without defaults' do
        expect(item.identification.attributes.size).to eq 0
        expect(item.identification).to respond_to(:to_hash)
        expect(item.structural.attributes.size).to eq 0
        expect(item.structural).to respond_to(:to_hash)
      end
    end
  end

  describe '.from_json' do
    subject(:item) { described_class.from_json(json) }

    context 'with minimal required properties' do
      let(:json) do
        required_properties.to_json
      end

      it 'populates required attributes passed in' do
        if required_properties[:externalIdentifier]
          expect(item.externalIdentifier).to eq required_properties[:externalIdentifier]
        end
        expect(item.label).to eq required_properties[:label]
        expect(item.type).to eq required_properties[:type]
        expect(item.version).to eq required_properties[:version]
      end

      it 'populates non-passed required attributes with default values' do
        expect(item.administrative).to be_kind_of(Cocina::Models::File::Administrative)
        expect(item.administrative.shelve).to be false
        expect(item.administrative.sdrPreserve).to be false

        expect(item.hasMessageDigests).to eq []
      end
    end

    context 'with optional attributes' do
      let(:json) do
        <<~JSON
          {
            "access": {
              "access": "world"
            },
            "administrative":{
              "sdrPreserve":false,
              "shelve":true
            },
            "externalIdentifier": "druid:ab123cd4567",
            "filename": "filename!!",
            "label": "nrs_19180211_0003.tiff",
            "hasMessageDigests": [
              {
                "type": "md5",
                "digest": "d57db4241d7da0eecba5b33abf13f448"
              },
              {
                "type": "sha1",
                "digest": "600a43324ea40ae1ba0c7ffa83965830d384c086"
              }
            ],
            "hasMimeType": "image/tiff",
            "presentation": {
              "height": 5679,
              "width": 4437
            },
            "size": 25243531,
            "type": "#{file_type}",
            "use": "transcription",
            "version": 3
          }
        JSON
      end

      it 'populates required attributes passed in' do
        if required_properties[:externalIdentifier]
          expect(item.externalIdentifier).to eq required_properties[:externalIdentifier]
        end
        expect(item.label).to eq 'nrs_19180211_0003.tiff'
        expect(item.type).to eq file_type
        expect(item.version).to eq 3
      end

      it 'populates all optional attributes passed in' do
        expect(item.access).to be_kind_of(Cocina::Models::File::Access)
        expect(item.access.access).to eq 'world'

        expect(item.administrative).to be_kind_of(Cocina::Models::File::Administrative)
        expect(item.administrative.sdrPreserve).to be false
        expect(item.administrative.shelve).to be true

        expect(item.filename).to eq 'filename!!'

        expect(item.hasMessageDigests).to be_kind_of(Array)
        expect(item.hasMessageDigests).to all(be_kind_of(Cocina::Models::File::Fixity))
        fixity = item.hasMessageDigests.first
        expect(fixity.type).to eq 'md5'
        expect(fixity.digest).to eq 'd57db4241d7da0eecba5b33abf13f448'

        expect(item.hasMimeType).to eq 'image/tiff'

        expect(item.presentation).to be_kind_of(Cocina::Models::File::Presentation)
        expect(item.presentation.height).to eq 5679
        expect(item.presentation.width).to eq 4437

        expect(item.size).to eq 25_243_531
        expect(item.use).to eq 'transcription'
      end
    end
  end
end
