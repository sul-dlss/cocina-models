# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Builders::TitleBuilder do
  subject(:builder_build) { described_class.build(cocina_titles, strategy: strategy, add_punctuation: add_punctuation) }

  let(:cocina_titles) { titles.map { |hash| Cocina::Models::Title.new(hash) } }
  let(:strategy) { :first }
  let(:add_punctuation) { true }
  let(:druid) { 'druid:bc753qt7345' }
  let(:main_title) { described_class.main_title(cocina_titles) }

  context 'with a DRO instead of cocina_titles (deprecated)' do
    subject(:builder_build) { described_class.build(cocina_object, strategy: strategy, add_punctuation: add_punctuation) }

    before do
      allow(Deprecation).to receive(:warn)
    end

    let(:cocina_object) do
      build(:dro, id: druid).new(description: description)
    end

    let(:description) do
      {
        title: [
          { value: 'However am I going to be' }
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    it '.build returns the first title as a string and logs a deprecation' do
      expect(builder_build).to eq('However am I going to be')
      expect(Deprecation).to have_received(:warn)
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

    it '.build returns the expected title strings from parallel value' do
      expect(builder_build).to eq [['The master and Margarita', 'Мастер и Маргарита']]
    end

    it 'main_title returns the expected string' do
      expect(main_title).to eq 'The master and Margarita'
    end
  end

  context 'with untyped titles' do
    let(:titles) do
      [
        { value: 'However am I going to be' },
        { value: 'A second title' }
      ]
    end

    it 'main_title is first title' do
      expect(main_title).to eq 'However am I going to be'
    end

    context 'with a :first strategy' do
      it '.build returns the first title' do
        expect(builder_build).to eq('However am I going to be')
      end
    end

    context 'with an :all strategy' do
      let(:strategy) { :all }

      it '.build returns an array with each title string' do
        expect(builder_build).to eq(['However am I going to be', 'A second title'])
      end
    end
  end

  context 'with a primary title' do
    let(:titles) do
      [
        { value: 'A very silly secondary title' },
        { value: 'A very silly primary title', status: 'primary' }
      ]
    end

    context 'with a :first strategy' do
      it '.build returns primary title string' do
        expect(builder_build).to eq('A very silly primary title')
      end
    end

    context 'with an :all strategy' do
      let(:strategy) { :all }

      it '.build returns an array with each title string' do
        expect(builder_build).to eq(['A very silly secondary title', 'A very silly primary title'])
      end
    end

    it 'main title returns primary title string' do
      expect(main_title).to eq 'A very silly primary title'
    end
  end

  context 'with a main title' do
    let(:titles) do
      [
        # NOTE:  these should be in a structuredValue so it gives weird results
        { value: 'A very silly subtitle', type: 'subtitle' },
        { value: 'A very silly main title', type: 'main title' }
      ]
    end

    context 'with a :first strategy' do
      it '.build returns the first title' do
        expect(builder_build).to eq('A very silly subtitle')
      end
    end

    context 'with an :all strategy' do
      let(:strategy) { :all }

      it '.build returns the main title' do
        expect(builder_build).to eq(['A very silly subtitle', 'A very silly main title'])
      end
    end

    it 'main_title is ... main title' do
      expect(main_title).to eq 'A very silly subtitle' # due to example weirdness
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

    it '.build returns the reconstructed title' do
      expect(builder_build).to eq('ti1:nonSort brisk junket : ti1:subTitle. ti1:partNumber, ti1:partName')
    end

    it 'main_title returns the main title with nonsorting characters' do
      expect(main_title).to eq 'ti1:nonSort brisk junket'
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

    it '.build returns the reconstructed nested structured title' do
      expect(builder_build).to eq('brisk junketti1:nonSort')
    end

    it 'main_title returns the first main title starting with nonsorting characters' do
      expect(main_title).to eq 'ti1:nonSort brisk junket'
    end
  end

  context 'when the structuredValue has part name and part number only' do
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
      it '.build returns the reconstructed structured title' do
        expect(builder_build).to eq('ti1:partNumber, ti1:partName')
      end
    end

    context 'when add punctuation is false' do
      let(:add_punctuation) { false }

      it '.build returns the reconstructed structured title without punctuation' do
        expect(builder_build).to eq('ti1:partNumber ti1:partName')
      end
    end

    it 'main_title returns the empty string' do
      expect(main_title).to eq ''
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

    it 'main_title returns the value for type "title"' do
      expect(main_title).to eq 'A random title'
    end

    context 'when add punctuation is default true' do
      it '.build returns the structured title' do
        expect(builder_build).to eq('A random subtitleA random title')
      end
    end

    context 'when add punctuation is false' do
      let(:add_punctuation) { false }

      it '.build returns the structured title without punctuation' do
        expect(builder_build).to eq('A random subtitleA random title')
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

    it 'main_title returns value for type "title"' do
      expect(main_title).to eq 'A Title'
    end

    context 'when add punctuation is default true' do
      it '.build returns the reconstructed structured title with punctuation' do
        expect(builder_build).to eq('The first subtitle : The second subtitleA Title')
      end
    end

    context 'when add punctuation is false' do
      let(:add_punctuation) { false }

      it '.build returns the reconstructed structured title without punctuation' do
        expect(builder_build).to eq('The first subtitle The second subtitleA Title')
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
            value: 'subtitle',
            type: 'subtitle'
          },
          {
            value: 'A Random Title'
          }
        ]
      ]
    end

    it '.build returns the untyped value (rather than subtitle)' do
      expect(builder_build).to eq('A Random Title')
    end

    it 'main_title returns the untyped value (rather than subtitle)' do
      expect(main_title).to eq 'A Random Title'
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

    it '.build returns the title with non sorting characters included' do
      expect(builder_build).to eq('The  means to prosperity')
    end

    it 'main_title returns the title with non sorting characters included' do
      expect(main_title).to eq 'The  means to prosperity'
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

    it '.build returns the title with non sorting characters included' do
      expect(builder_build).to eq('The means to prosperity')
    end

    it 'main_title returns the title with non sorting characters included' do
      expect(main_title).to eq('The means to prosperity')
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

    it '.build returns the title with non sorting characters included' do
      expect(builder_build).to eq('The-means to prosperity')
    end

    it 'main_title returns the title with non sorting characters included' do
      expect(main_title).to eq('The-means to prosperity')
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

    it '.build returns the title with non sorting characters included' do
      expect(builder_build).to eq('L\'means to prosperity')
    end

    it 'main_title returns the title with non sorting characters included' do
      expect(main_title).to eq('L\'means to prosperity')
    end
  end
end
