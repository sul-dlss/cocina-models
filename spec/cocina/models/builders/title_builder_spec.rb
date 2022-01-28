# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Builders::TitleBuilder do
  subject(:build) { described_class.build(cocina_titles, strategy: strategy, add_punctuation: add_punctuation) }

  let(:cocina_titles) { titles.map { |hash| Cocina::Models::Title.new(hash) } }
  let(:strategy) { :first }
  let(:add_punctuation) { true }
  let(:druid) { 'druid:bc753qt7345' }
  let(:apo_druid) { 'druid:pp000pp0000' }

  context 'with a DRO (deprecated)' do
    subject(:build) { described_class.build(cocina_object, strategy: strategy, add_punctuation: add_punctuation) }

    before do
      allow(Deprecation).to receive(:warn)
    end

    let(:cocina_object) do
      Cocina::Models::DRO.new(externalIdentifier: druid,
                              type: Cocina::Models::ObjectType.object,
                              label: 'A new map of Africa',
                              version: 1,
                              description: description,
                              identification: { sourceId: 'sul:123' },
                              access: {},
                              administrative: { hasAdminPolicy: apo_druid },
                              structural: {})
    end
    let(:description) do
      {
        title: [
          { value: 'However am I going to be' }
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    it 'returns the first title object and logs a deprecation' do
      expect(build).to eq('However am I going to be')
      expect(Deprecation).to have_received(:warn).exactly(4).times
    end
  end

  context 'with a DescriptiveValue (such as a subject with type = title)' do
    let(:cocina_titles) { descriptive_values.map { |hash| Cocina::Models::DescriptiveValue.new(hash) } }
    let(:strategy) { :all }
    let(:add_punctuation) { false }

    let(:descriptive_values) do
      [{
        parallelValue: [
          {
            value: 'The master and Margarita'
          },
          {
            value: 'Мастер и Маргарита'
          }
        ],
        type: 'title'
      }]
    end

    it 'returns the expected title' do
      expect(build).to eq [['The master and Margarita', 'Мастер и Маргарита']]
    end
  end

  context 'with untyped titles' do
    let(:titles) do
      [
        { value: 'However am I going to be' },
        { value: 'A second title' }
      ]
    end

    context 'with a :first strategy' do
      it 'returns the first title object' do
        expect(build).to eq('However am I going to be')
      end
    end

    context 'with an :all strategy' do
      let(:strategy) { :all }

      it 'returns an array with each title object' do
        expect(build).to eq(['However am I going to be', 'A second title'])
      end
    end
  end

  context 'with a primary title' do
    let(:titles) do
      [
        { value: 'A very silly primary title', status: 'primary' },
        { value: 'A very silly secondary title' }
      ]
    end

    it 'returns the first title object' do
      expect(build).to eq('A very silly primary title')
    end
  end

  context 'with a main title' do
    let(:titles) do
      [
        { value: 'A very silly main title', type: 'main title' },
        { value: 'A very silly sub title', type: 'subtitle' }
      ]
    end

    context 'with a :first strategy' do
      it 'returns the main title object' do
        expect(build).to eq('A very silly main title')
      end
    end

    context 'with an :all strategy' do
      let(:strategy) { :all }

      it 'returns the main title object' do
        expect(build).to eq(['A very silly main title', 'A very silly sub title'])
      end
    end
  end

  context 'when the titles are in a structuredValue' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:titles) do
      # Yes, there can be a structuredValue inside a StructuredValue.  For example,
      # a uniform title where both the name and the title have internal StructuredValue
      [
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
      ]
    end

    it 'returns the structured title' do
      expect(build).to eq('ti1:nonSort brisk junket : ti1:subTitle. ti1:partNumber, ti1:partName')
    end
  end

  context 'when the titles are in nested structuredValues' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:titles) do
      # Yes, there can be a structuredValue inside a StructuredValue.  For example,
      # a uniform title where both the name and the title have internal StructuredValue
      [
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
      ]
    end

    it 'returns the first structured title' do
      expect(build).to eq('brisk junketti1:nonSort')
    end
  end

  context 'when the title parts are in a structuredValue' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:titles) do
      # Yes, there can be a structuredValue inside a StructuredValue.  For example,
      # a uniform title where both the name and the title have internal StructuredValue
      [
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
      ]
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
    let(:titles) do
      # Yes, there can be a structuredValue inside a StructuredValue.  For example,
      # a uniform title where both the name and the title have internal StructuredValue
      [
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
      ]
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
    let(:titles) do
      # Yes, there can be a structuredValue inside a StructuredValue.  For example,
      # a uniform title where both the name and the title have internal StructuredValue
      [
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
      ]
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
    let(:titles) do
      # Yes, there can be a structuredValue inside a StructuredValue.  For example,
      # a uniform title where both the name and the title have internal StructuredValue
      [
        parallelValue: [
          {
            value: 'A Random sub title',
            type: 'subtitle'
          },
          {
            value: 'A Random Title'
          }
        ]
      ]
    end

    it 'returns the correct title' do
      expect(build).to eq('A Random Title')
    end
  end

  context 'when multiple nonsorting characters with note' do
    let(:titles) do
      [
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
      ]
    end

    it 'returns the title with non sorting characters included' do
      expect(build).to eq('The  means to prosperity')
    end
  end

  context 'when multiple nonsorting characters without note' do
    let(:titles) do
      [
        structuredValue: [
          {
            value: 'The',
            type: 'nonsorting characters'
          }, {
            value: 'means to prosperity',
            type: 'main title'
          }
        ]
      ]
    end

    it 'returns the title with non sorting characters included' do
      expect(build).to eq('The means to prosperity')
    end
  end

  context 'when multiple nonsorting characters without note, ends in dash' do
    let(:titles) do
      [
        structuredValue: [
          {
            value: 'The-',
            type: 'nonsorting characters'
          }, {
            value: 'means to prosperity',
            type: 'main title'
          }
        ]
      ]
    end

    it 'returns the title with non sorting characters included' do
      expect(build).to eq('The-means to prosperity')
    end
  end

  context 'when multiple nonsorting characters without note, ends in apostrophe' do
    let(:titles) do
      [
        structuredValue: [
          {
            value: 'L\'',
            type: 'nonsorting characters'
          }, {
            value: 'means to prosperity',
            type: 'main title'
          }
        ]
      ]
    end

    it 'returns the title with non sorting characters included' do
      expect(build).to eq('L\'means to prosperity')
    end
  end
end
