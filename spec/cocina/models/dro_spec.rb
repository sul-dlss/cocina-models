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
          label: 'My object',
          version: 3
        }
      end

      it 'has properties' do
        expect(item.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(item.type).to eq 'item'
        expect(item.label).to eq 'My object'

        expect(item.access).to be_kind_of Cocina::Models::DRO::Access
      end
    end

    context 'with a all properties' do
      let(:properties) do
        {
          externalIdentifier: 'druid:ab123cd4567',
          type: 'item',
          label: 'My object',
          version: 3,
          access: {
            embargoReleaseDate: '2009-12-14T07:00:00Z'
          },
          administrative: {
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
          }
        }
      end

      it 'has properties' do
        expect(item.externalIdentifier).to eq 'druid:ab123cd4567'
        expect(item.type).to eq 'item'
        expect(item.label).to eq 'My object'

        expect(item.access.embargoReleaseDate).to eq DateTime.parse('2009-12-14T07:00:00Z')
        expect(item.administrative.releaseTags).to all(be_kind_of(Cocina::Models::DRO::ReleaseTag))
        tag = item.administrative.releaseTags.first
        expect(tag.date).to eq DateTime.parse '2018-11-23T00:44:52Z'
        expect(tag.to).to eq 'Searchworks'
        expect(tag.release).to be true
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
            "label":"my item",
            "version": 3
          }
        JSON
      end

      it 'has the attributes' do
        expect(dro.attributes).to include(externalIdentifier: 'druid:12343234',
                                          label: 'my item',
                                          type: 'item')
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
            "type":"item",
            "label":"my item",
            "version": 3,
            "access": {
              "embargoReleaseDate":"2009-12-14T07:00:00Z"
            },
            "administrative": {
              "releaseTags": [
                {
                  "who":"Justin",
                  "what":"collection",
                  "date":"2018-11-23T00:44:52Z",
                  "to":"",
                  "release":"true"
                },
                {
                  "who":"Other Justin",
                  "what":"self",
                  "date":"2017-10-20T15:42:15Z",
                  "to":"",
                  "release":"false"
                }
              ]
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
