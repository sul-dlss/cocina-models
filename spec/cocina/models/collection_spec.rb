# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Collection do
  let(:collection_type) { 'http://cocina.sul.stanford.edu/models/collection.jsonld' }

  describe 'initialization' do
    subject(:collection) { described_class.new(properties) }

    context 'with a minimal set' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: collection_type,
          label: 'My collection',
          version: 3
        }
      end

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
          version: '3'
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
          },
          administrative: {
          }
        }
      end

      it 'has properties' do
        expect(collection.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(collection.type).to eq collection_type
        expect(collection.label).to eq 'My collection'
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
            "version": 3
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
            },
            "administrative": {
            }
          }
        JSON
      end

      it 'has the attributes' do
        expect(collection.attributes).to include(externalIdentifier: 'druid:12343234',
                                                 label: 'my collection',
                                                 type: collection_type)
      end
    end
  end
end
