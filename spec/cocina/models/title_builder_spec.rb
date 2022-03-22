# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::TitleBuilder do
  subject(:build) { described_class.build(cocina_object, strategy: strategy, add_punctuation: add_punctuation) }

  let(:strategy) { :first }
  let(:add_punctuation) { true }
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
                            administrative: { hasAdminPolicy: apo_druid },
                            structural: {})
  end

  context 'with untyped titles' do
    let(:description) do
      {
        title: [
          { value: 'However am I going to be' },
          { value: 'A second title' }
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    context 'with a :first strategy' do
      it 'returns the first tile object' do
        expect(build).to eq('However am I going to be')
      end
    end

    context 'with an :all strategy' do
      let(:strategy) { :all }

      it 'returns an array with each tile object' do
        expect(build).to eq(['However am I going to be', 'A second title'])
      end
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

  context 'with a main title' do
    let(:description) do
      {
        title: [
          { value: 'A very silly main title', type: 'main title' },
          { value: 'A very silly sub title', type: 'subtitle' }
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    context 'with a :first strategy' do
      it 'returns the main tile object' do
        expect(build).to eq('A very silly main title')
      end
    end

    context 'with an :all strategy' do
      let(:strategy) { :all }

      it 'returns the main tile object' do
        expect(build).to eq(['A very silly main title', 'A very silly sub title'])
      end
    end
  end

  context 'when the titles are in a structuredValue' do
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

  context 'when the titles are in nested structuredValues' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:description) do
      {
        # Yes, there can be a structuredValue inside a StructuredValue.  For example,
        # a uniform title where both the name and the title have internal StructuredValue
        title: [
          structuredValue: [
            {
              structuredValue: [
                {
                  value: 'brisk junket',
                  type: 'main title'
                },
                {
                  value: 'ti1:nonSort',
                  type: 'nonsorting characters'
                }
              ]
            }
          ]
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    it 'returns the first structured title' do
      expect(build).to eq('brisk junketti1:nonSort')
    end
  end

  context 'when the title parts are in a structuredValue' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:description) do
      {
        # Yes, there can be a structuredValue inside a StructuredValue.  For example,
        # a uniform title where both the name and the title have internal StructuredValue
        title: [
          structuredValue: [
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

    context 'when add punctuation is default true' do
      it 'returns the structured title' do
        expect(build).to eq('ti1:partNumber, ti1:partName')
      end
    end

    context 'when add punctuation is false' do
      let(:add_punctuation) { false }

      it 'reeturns the structured title without punctuation' do
        expect(build).to eq('ti1:partNumber ti1:partName')
      end
    end
  end

  context 'when a subtitle is in a structuredValue' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:description) do
      {
        # Yes, there can be a structuredValue inside a StructuredValue.  For example,
        # a uniform title where both the name and the title have internal StructuredValue
        title: [
          structuredValue: [
            {
              value: 'A random subtitle',
              type: 'subtitle'
            },
            {
              value: 'A random title',
              type: 'title'
            }
          ]
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    context 'when add punctuation is default true' do
      it 'returns the structured title' do
        expect(build).to eq('A random subtitleA random title')
      end
    end

    context 'when add punctuation is false' do
      let(:add_punctuation) { false }

      it 'reeturns the structured title without punctuation' do
        expect(build).to eq('A random subtitleA random title')
      end
    end
  end

  context 'when multiple subtitles are in a structuredValue' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:description) do
      {
        # Yes, there can be a structuredValue inside a StructuredValue.  For example,
        # a uniform title where both the name and the title have internal StructuredValue
        title: [
          structuredValue: [
            {
              value: 'The first subtitle',
              type: 'subtitle'
            },
            {
              value: 'The second subtitle',
              type: 'subtitle'
            },
            {
              value: 'A Title',
              type: 'title'
            }
          ]
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    context 'when add punctuation is default true' do
      it 'returns the structured title' do
        expect(build).to eq('The first subtitle : The second subtitleA Title')
      end
    end

    context 'when add punctuation is false' do
      let(:add_punctuation) { false }

      it 'reeturns the structured title without punctuation' do
        expect(build).to eq('The first subtitle The second subtitleA Title')
      end
    end
  end

  context 'when the titles are in a parallelValue' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:description) do
      {
        # Yes, there can be a structuredValue inside a StructuredValue.  For example,
        # a uniform title where both the name and the title have internal StructuredValue
        title: [
          parallelValue: [
            {
              value: 'A Random sub title',
              type: 'subtitle'
            },
            {
              value: 'A Random Title'
            }
          ]
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    it 'returns the correct title' do
      expect(build).to eq('A Random sub title')
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
