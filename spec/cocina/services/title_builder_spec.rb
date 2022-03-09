# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Services::TitleBuilder do
  subject(:build) { described_class.build(cocina_object) }

  let(:druid) { 'druid:bc753qt7345' }
  let(:apo_druid) { 'druid:pp000pp0000' }
  let(:cocina_object) do
    Cocina::Models::DRO.new(externalIdentifier: druid,
                            type: Cocina::Models::ObjectType.object,
                            label: 'A new map of Africa',
                            version: 1,
                            description: description,
                            identification: {},
                            access: {},
                            administrative: { hasAdminPolicy: apo_druid })
  end

  context 'with an untyped title' do
    let(:description) do
      {
        title: [{ value: 'However am I going to be' }],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    it 'returns the first tile object' do
      expect(build).to eq('However am I going to be')
    end
  end

  context 'with a primary title' do
    let(:description) do
      {
        title: [
          { value: 'A very silly primary title', status: 'primary' },
          { value: 'A very silly secondary title' }
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    it 'returns the first tile object' do
      expect(build).to eq('A very silly primary title')
    end
  end

  context 'when structuredValue in structuredValue' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:description) do
      {
        # Yes, there can be a structuredValue inside a StructuredValue.  For example,
        # a uniform title where both the name and the title have internal StructuredValue
        title: [
          structuredValue: [
            {
              value: 'ti1:nonSort',
              type: 'nonsorting characters'
            },
            {
              value: 'brisk junket',
              type: 'main title'
            },
            {
              value: 'ti1:subTitle',
              type: 'subtitle'
            },
            {
              value: 'ti1:partNumber',
              type: 'part number'
            },
            {
              value: 'ti1:partName',
              type: 'part name'
            }
          ]
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    it 'returns the structured title' do
      expect(build).to eq('ti1:nonSortbrisk junket : ti1:subTitle. ti1:partNumber, ti1:partName')
    end
  end

  context 'when multiple nonsorting characters' do
    let(:description) do
      {
        title: [
          structuredValue: [
            {
              value: 'The',
              type: 'nonsorting characters'
            }, {
              value: 'means to prosperity',
              type: 'main title'
            }
          ],
          note: [
            {
              value: '5',
              type: 'nonsorting character count'
            }
          ]
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    it 'returns the title with non sorting characters included' do
      expect(build).to eq('The  means to prosperity')
    end
  end
end
