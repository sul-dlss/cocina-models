# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::DRO do
  describe 'initialization' do
    subject(:item) { described_class.new(properties) }

    context 'with a minimal set' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: 'item',
          label: 'My object'
        }
      end

      it 'has properties' do
        expect(item.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(item.type).to eq 'item'
        expect(item.label).to eq 'My object'

        expect(item.access).to be_nil
      end
    end

    context 'with a all properties' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: 'item',
          label: 'My object',
          access: {
            embargoReleaseDate: '2009-12-14T07:00:00Z'
          }
        }
      end

      it 'has properties' do
        expect(item.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(item.type).to eq 'item'
        expect(item.label).to eq 'My object'

        expect(item.access.embargoReleaseDate).to eq DateTime.parse('2009-12-14T07:00:00Z')
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
            "type":"item",
            "label":"my item"
          }
        JSON
      end

      it 'has the attributes' do
        expect(dro.attributes).to include(externalIdentifier: 'druid:12343234',
                                          label: 'my item',
                                          type: 'item')
        expect(dro.access).to be_nil
      end
    end

    context 'with a full object' do
      let(:json) do
        <<~JSON
          {
            "externalIdentifier":"druid:12343234",
            "type":"item",
            "label":"my item",
            "access": {
              "embargoReleaseDate":"2009-12-14T07:00:00Z"
            }
          }
        JSON
      end

      it 'has the attributes' do
        expect(dro.attributes).to include(externalIdentifier: 'druid:12343234',
                                          label: 'my item',
                                          type: 'item')
        access_attributes = dro.attributes[:access].attributes
        expect(access_attributes).to eq(embargoReleaseDate: DateTime.parse('2009-12-14T07:00:00Z'))
      end
    end
  end
end
