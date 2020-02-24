# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::RequestFile do
  subject(:item) { described_class.new(properties) }

  let(:file_type) { 'http://cocina.sul.stanford.edu/models/file.jsonld' }

  describe 'initialization' do
    context 'with a minimal set' do
      let(:properties) do
        {
          type: file_type,
          label: 'My file',
          version: 3
        }
      end

      it 'has properties' do
        expect(item.type).to eq file_type
        expect(item.label).to eq 'My file'
      end
    end

    context 'with a string version' do
      let(:properties) do
        {
          type: file_type,
          label: 'My file',
          version: '3'
        }
      end

      it 'coerces to integer' do
        expect(item.version).to eq 3
      end
    end

    context 'with a all properties' do
      let(:properties) do
        {
          access: {
            access: 'citation-only'
          },
          type: file_type,
          label: 'My file',
          version: 3,
          administrative: {
            shelve: true,
            sdrPreserve: false
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
          ],
          hasMimeType: 'image/jp2'
        }
      end

      it 'has properties' do
        expect(item.access.access).to eq 'citation-only'

        expect(item.hasMimeType).to eq 'image/jp2'
        expect(item.type).to eq file_type
        expect(item.label).to eq 'My file'

        expect(item.hasMessageDigests).to all(be_kind_of(Cocina::Models::File::Fixity))
        fixity = item.hasMessageDigests.first
        expect(fixity.type).to eq 'md5'
        expect(fixity.digest).to eq 'd57db4241d7da0eecba5b33abf13f448'

        expect(item.administrative.shelve).to be true
        expect(item.administrative.sdrPreserve).to be false
      end
    end
  end

  describe '.from_dynamic' do
    subject(:item) { described_class.from_dynamic(properties) }

    context 'with empty subschemas' do
      let(:properties) do
        {
          'type' => file_type,
          'label' => 'Examination of the memorial of the owners and underwriters ...',
          'version' => 1,
          'access' => {},
          'hasMessageDigests' => [
            {
              'type' => 'md5',
              'digest' => 'd57db4241d7da0eecba5b33abf13f448'
            }
          ],
          'identification' => {},
          'structural' => {}
        }
      end

      it 'has properties' do
        expect(item.type).to eq file_type
      end
    end
  end

  describe '.from_json' do
    subject(:file) { described_class.from_json(json) }

    context 'with a minimal object' do
      let(:json) do
        <<~JSON
          {
            "type":"#{file_type}",
            "label":"my item",
            "version": 3
          }
        JSON
      end

      it 'has the attributes' do
        expect(file.attributes).to include(label: 'my item',
                                           type: file_type)
      end
    end

    context 'with a full object' do
      let(:json) do
        <<~JSON
          {
            "access": {
              "access":"world"
            },
            "administrative":{
              "sdrPreserve":false,
              "shelve":true
            },
            "type":"#{file_type}",
            "label":"nrs_19180211_0003.tiff",
            "size":25243531,
            "version": 3,
            "use": "transcription",
            "presentation": {
              "height":5679,
              "width":4437
            },
            "hasMessageDigests": [
              {
                "type":"md5",
                "digest":"d57db4241d7da0eecba5b33abf13f448"
              },
              {
                "type":"sha1",
                "digest":"600a43324ea40ae1ba0c7ffa83965830d384c086"
              }
            ],
            "hasMimeType":"image/jp2"
          }
        JSON
      end

      it 'has the attributes' do
        expect(file.attributes).to include(label: 'nrs_19180211_0003.tiff',
                                           type: file_type,
                                           hasMimeType: 'image/jp2')

        expect(file.access.access).to eq 'world'

        digests = file.hasMessageDigests
        expect(digests).to all(be_instance_of Cocina::Models::File::Fixity)
        expect(digests.first.type).to eq 'md5'

        expect(file.presentation.height).to eq 5679
        expect(file.presentation.width).to eq 4437
        expect(file.size).to eq 25_243_531
        expect(file.use).to eq 'transcription'

        expect(file.administrative.shelve).to be true
        expect(file.administrative.sdrPreserve).to be false
      end
    end
  end
end
