# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::FileSet do
  let(:file_set_type) { 'http://cocina.sul.stanford.edu/models/fileset.jsonld' }

  describe 'initialization' do
    subject(:item) { described_class.new(properties) }

    context 'with a minimal set' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: file_set_type,
          label: 'My file',
          version: 3
        }
      end

      it 'has properties' do
        expect(item.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(item.type).to eq file_set_type
        expect(item.label).to eq 'My file'
      end
    end

    context 'with a string version' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: file_set_type,
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
          externalIdentifier: 'druid:ab123cd4567',
          type: file_set_type,
          label: 'My file',
          version: 3,
          administrative: {
          },
          structural: {
            contains: [
              'file#1',
              'file#2'
            ]
          }
        }
      end

      it 'has properties' do
        expect(item.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(item.type).to eq file_set_type
        expect(item.label).to eq 'My file'

        expect(item.structural.contains).to eq ['file#1', 'file#2']
      end
    end
  end

  describe '.from_dynamic' do
    subject(:item) { described_class.from_dynamic(properties) }

    context 'with empty subschemas' do
      let(:properties) do
        {
          'externalIdentifier' => 'druid:kv840rx2720',
          'type' => file_set_type,
          'label' => 'Examination of the memorial of the owners and underwriters ...',
          'version' => 1,
          'access' => {},
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
            "type":"#{file_set_type}",
            "label":"my item",
            "version": 3
          }
        JSON
      end

      it 'has the attributes' do
        expect(dro.attributes).to include(externalIdentifier: 'druid:12343234',
                                          label: 'my item',
                                          type: file_set_type)
        expect(dro.identification).to be_kind_of Cocina::Models::FileSet::Identification
        expect(dro.structural).to be_kind_of Cocina::Models::FileSet::Structural
      end
    end

    context 'with a full object' do
      let(:json) do
        <<~JSON
          {
            "externalIdentifier":"druid:12343234",
            "type":"#{file_set_type}",
            "label":"nrs_19180211_0003.tiff",
            "size":25243531,
            "version": 3,
            "structural": {
              "contains": [
                "file#1",
                "file#2"
              ]
            }
          }
        JSON
      end

      it 'has the attributes' do
        expect(dro.attributes).to include(externalIdentifier: 'druid:12343234',
                                          label: 'nrs_19180211_0003.tiff',
                                          type: file_set_type)

        expect(dro.structural.contains).to eq ['file#1', 'file#2']
      end
    end
  end
end
