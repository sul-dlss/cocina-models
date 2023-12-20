# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Builders::TitleBuilder do
  subject(:builder_build) { described_class.build(cocina_titles, strategy: strategy, add_punctuation: add_punctuation) }

  let(:cocina_titles) { titles.map { |hash| Cocina::Models::Title.new(hash) } }
  let(:strategy) { :first }
  let(:add_punctuation) { true }
  let(:druid) { 'druid:bc753qt7345' }
  let(:main_title) { described_class.main_title(cocina_titles) }
  let(:full_title) { described_class.full_title(cocina_titles) }
  let(:additional_titles) { described_class.additional_titles(cocina_titles) }

  context 'with a DRO instead of cocina_titles (deprecated)' do
    subject(:builder_build) { described_class.build(cocina_object, strategy: strategy, add_punctuation: add_punctuation) }

    before do
      allow(Deprecation).to receive(:warn)
    end

    let(:main_title) { described_class.main_title(cocina_object) }
    let(:full_title) { described_class.full_title(cocina_object) }
    let(:cocina_object) { build(:dro, id: druid).new(description: description) }
    let(:description) do
      {
        title: [
          { value: 'However am I going to be' }
        ],
        purl: 'https://purl.stanford.edu/bc753qt7345'
      }
    end

    it '.build returns the title as a string and logs a deprecation' do
      expect(builder_build).to eq('However am I going to be')
      expect(Deprecation).to have_received(:warn)
    end
  end

  context 'with a DescriptiveValue (such as a subject with type = title) that is a parallelValue' do
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
      expect(builder_build).to eq ['The master and Margarita', 'Мастер и Маргарита']
    end

    it '.main_title returns the first title string' do
      expect(main_title).to eq 'The master and Margarita'
    end

    it '.full_title returns the first title string from parallel value' do
      expect(full_title).to eq 'The master and Margarita'
    end

    it '.additional_titles returns the second title string from parallel value' do
      expect(additional_titles).to eq ['Мастер и Маргарита']
    end
  end

  context 'with untyped titles' do
    let(:titles) do
      [
        { value: 'However am I going to be' },
        { value: 'A second title' }
      ]
    end

    it '.main_title is first title' do
      expect(main_title).to eq 'However am I going to be'
    end

    it '.full_title is first title' do
      expect(full_title).to eq 'However am I going to be'
    end

    it '.additional_titles is second title' do
      expect(additional_titles).to eq ['A second title']
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

    it '.main_title returns primary title string' do
      expect(main_title).to eq 'A very silly primary title'
    end

    it '.full_title returns primary title string' do
      expect(full_title).to eq 'A very silly primary title'
    end

    it '.additional_titles returns non-primary title string(s)' do
      expect(additional_titles).to eq ['A very silly secondary title']
    end
  end

  context 'with a main title (but no structuredValue)' do
    let(:titles) do
      [
        # NOTE:  these should be in a structuredValue; because they are not, we get weird results
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

    it 'main_title is ... first value because this should be a structuredValue' do
      expect(main_title).to eq 'A very silly subtitle'
    end

    it 'full_title is ... first value because this should be a structuredValue' do
      expect(full_title).to eq 'A very silly subtitle'
    end

    it 'additional_titles is second value because this should be a structuredValue' do
      expect(additional_titles).to eq ['A very silly main title']
    end
  end

  context 'when the title is in a structuredValue' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:titles) do
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

    it '.main_title returns the main title with nonsorting characters' do
      expect(main_title).to eq 'ti1:nonSort brisk junket'
    end

    it '.full_title returns the reconstructed title without punctuation' do
      expect(full_title).to eq('ti1:nonSort brisk junket ti1:subTitle ti1:partNumber ti1:partName')
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
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
      expect(builder_build).to eq('ti1:nonSort brisk junket')
    end

    it '.full_title returns the reconstructed nested structured title' do
      expect(full_title).to eq('ti1:nonSort brisk junket')
    end

    it '.main_title returns the first main title starting with nonsorting characters' do
      expect(main_title).to eq 'ti1:nonSort brisk junket'
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
    end
  end

  context 'when the structuredValue has part name and part number only' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:titles) do
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
      it '.build returns the reconstructed structured title with punctuation' do
        expect(builder_build).to eq('ti1:partNumber, ti1:partName')
      end
    end

    context 'when add punctuation is false' do
      let(:add_punctuation) { false }

      it '.build returns the reconstructed structured title without punctuation' do
        expect(builder_build).to eq('ti1:partNumber ti1:partName')
      end
    end

    it '.full_title returns the reconstructed structured title without punctuation' do
      expect(full_title).to eq 'ti1:partNumber ti1:partName'
    end

    it '.main_title returns the empty string' do
      expect(main_title).to eq ''
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
    end
  end

  context 'when a subtitle is in a structuredValue' do
    let(:titles) do
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

    it '.main_title returns the value for type "title"' do
      expect(main_title).to eq 'A random title'
    end

    it '.full_title returns the reconstructed structured title without punctuation' do
      expect(full_title).to eq('A random title A random subtitle')
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
    end

    context 'when add punctuation is default (true)' do
      it '.build returns the reconstructed structured title' do
        expect(builder_build).to eq('A random title : A random subtitle')
      end
    end

    context 'when add punctuation is false' do
      let(:add_punctuation) { false }

      it '.build returns the structured title without punctuation' do
        expect(builder_build).to eq('A random title A random subtitle')
      end
    end
  end

  context 'when multiple subtitles are in a structuredValue' do
    let(:titles) do
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

    it '.main_title returns value for type "title"' do
      expect(main_title).to eq 'A Title'
    end

    it '.full_title returns value for type "title" without punctuation' do
      expect(full_title).to eq 'A Title The first subtitle The second subtitle'
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
    end

    context 'when add punctuation is default true' do
      it '.build returns the reconstructed structured title with punctuation' do
        expect(builder_build).to eq('A Title : The first subtitle : The second subtitle')
      end
    end

    context 'when add punctuation is false' do
      let(:add_punctuation) { false }

      it '.build returns the reconstructed structured title without punctuation' do
        expect(builder_build).to eq('A Title The first subtitle The second subtitle')
      end
    end
  end

  context 'when the titles are in a parallelValue' do
    let(:titles) do
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

    it 'full_title returns the untyped value (rather than subtitle)' do
      expect(full_title).to eq 'A Random Title'
    end

    it '.additional_titles returns the parallelValue that is not the full_title' do
      expect(additional_titles).to eq ['subtitle']
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

    it '.main_title returns the title with non sorting characters included' do
      expect(main_title).to eq 'The  means to prosperity'
    end

    it '.full_title returns the title with non sorting characters included' do
      expect(full_title).to eq 'The  means to prosperity'
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

    it '.main_title returns the title with non sorting characters included' do
      expect(main_title).to eq('The means to prosperity')
    end

    it '.full_title returns the title with non sorting characters included' do
      expect(full_title).to eq('The means to prosperity')
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

    it '.main_title returns the title with non sorting characters included' do
      expect(main_title).to eq('The-means to prosperity')
    end

    it '.full_title returns the title with non sorting characters included' do
      expect(full_title).to eq('The-means to prosperity')
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

    it '.main_title returns the title with non sorting characters included' do
      expect(main_title).to eq('L\'means to prosperity')
    end

    it '.full_title returns the title with non sorting characters included' do
      expect(full_title).to eq('L\'means to prosperity')
    end
  end

  context 'when multiple titles with parallel values, status primary on half a parallel value' do
    # based on bb022pc9382
    let(:titles) do
      [
        {
          parallelValue: [
            {
              structuredValue: [
                {
                  value: 'Sefer Bet nadiv',
                  type: 'main title'
                },
                {
                  value: 'sheʼelot u-teshuvot, ḥidushe Torah, derashot',
                  type: 'subtitle'
                }
              ],
              status: 'primary'
            },
            {
              structuredValue: [
                {
                  value: 'hebrew main title',
                  type: 'main title'
                },
                {
                  value: 'hebrew subtitle',
                  type: 'subtitle'
                }
              ]
            }
          ]
        },
        {
          parallelValue: [
            {
              value: 'Bet nadiv',
              note: [
                {
                  structuredValue: [
                    {
                      value: 'Leṿin, Natan',
                      type: 'name'
                    },
                    {
                      value: '1856 or 1857-1926',
                      type: 'life dates'
                    }
                  ],
                  type: 'associated name'
                }
              ]
            },
            {
              value: 'hebrew uniform value',
              note: [
                {
                  value: 'hebrew associated name',
                  type: 'associated name'
                }
              ]
            }
          ],
          type: 'uniform'
        },
        {
          parallelValue: [
            {
              value: 'Bet nadiv',
              type: 'alternative'
            },
            {
              value: 'hebrew alternative',
              type: 'alternative'
            }
          ]
        }
      ]
    end

    it '.main_title is "main title" value from title with status "primary"' do
      # QUESTION: should this have the parallel value as well?
      # see https://github.com/sul-dlss/cocina-models/issues/657
      expect(main_title).to eq 'Sefer Bet nadiv'
    end

    it '.full_title is entire value from title with status "primary"' do
      expect(full_title).to eq 'Sefer Bet nadiv sheʼelot u-teshuvot, ḥidushe Torah, derashot'
    end

    it '.additional_titles is all but the full_title' do
      # QUESTION:  shouldn't the uniform titles start with the associated name?
      # see https://github.com/sul-dlss/cocina-models/issues/657
      actual_result = additional_titles
      [
        'hebrew main title hebrew subtitle',
        'Bet nadiv', # uniform
        'hebrew uniform value', # uniform
        'Bet nadiv', # alternative
        'hebrew alternative'
      ].each { |title| expect(actual_result).to include(title) }
      expect(actual_result.size).to eq(5)
    end

    context 'with a :first strategy' do
      it '.build returns the primary title' do
        expect(builder_build).to eq('Sefer Bet nadiv : sheʼelot u-teshuvot, ḥidushe Torah, derashot')
      end
    end

    context 'with an :all strategy' do
      let(:strategy) { :all }

      # QUESTION:  shouldn't the uniform titles start with the associated name?
      # see https://github.com/sul-dlss/cocina-models/issues/657
      it '.build returns an array with each title string' do
        actual_result = builder_build
        [
          'Sefer Bet nadiv : sheʼelot u-teshuvot, ḥidushe Torah, derashot',
          'hebrew main title : hebrew subtitle',
          'Bet nadiv', # uniform
          'hebrew uniform value', # uniform
          'Bet nadiv', # alternative
          'hebrew alternative'
        ].each { |title| expect(actual_result).to include(title) }
        expect(actual_result.size).to eq(6)
      end
    end
  end

  context 'with all valid title types, no primary' do
    # per https://github.com/sul-dlss/cocina-models/blob/main/description_types.yml
    let(:titles) do
      [
        {
          value: 'abbreviated',
          type: 'abbreviated'
        },
        {
          value: 'alternative',
          type: 'alternative'
        },
        {
          parallelValue: [
            {
              value: 'first parallel'
            },
            {
              value: 'second parallel'
            }
          ],
          type: 'parallel'
        },
        {
          value: 'supplied',
          type: 'supplied'
        },
        {
          value: 'translated',
          type: 'translated'
        },
        {
          value: 'transliterated',
          type: 'transliterated'
        },
        {
          value: 'uniform',
          type: 'uniform'
        }
      ]
    end

    it '.main_title is uniform title' do
      # QUESTION:  should this be uniform title?
      # see https://github.com/sul-dlss/cocina-models/issues/657
      expect(main_title).to eq 'first parallel' # first encountered
    end

    it '.full_title is first title' do
      # QUESTION:  should this be uniform title?
      # see https://github.com/sul-dlss/cocina-models/issues/657
      expect(full_title).to eq 'first parallel' # first encountered
    end

    it '.additional_titles is all but the full_title' do
      actual_result = additional_titles
      [
        'abbreviated',
        'alternative',
        # 'first parallel',
        'second parallel',
        'supplied',
        'translated',
        'transliterated',
        'uniform'
      ].each { |title| expect(actual_result).to include(title) }
      expect(actual_result.size).to eq(7)
    end

    context 'with a :first strategy' do
      # QUESTION:  should this be uniform title?
      # see https://github.com/sul-dlss/cocina-models/issues/657
      it '.build returns the first title' do
        expect(builder_build).to eq('first parallel')
      end
    end

    context 'with an :all strategy' do
      let(:strategy) { :all }

      it '.build returns an array with each title string' do
        actual_result = builder_build
        [
          'abbreviated',
          'alternative',
          'first parallel',
          'second parallel',
          'supplied',
          'translated',
          'transliterated',
          'uniform'
        ].each { |title| expect(actual_result).to include(title) }
        expect(actual_result.size).to eq(8)
      end
    end
  end
end
