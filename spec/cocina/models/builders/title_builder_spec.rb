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

    describe '.build' do
      context 'with strategy first' do
        it 'returns first title string from parallel value' do
          expect(builder_build).to eq 'The master and Margarita'
        end
      end

      context 'with strategy all' do
        let(:strategy) { :all }

        it 'returns both from parallel values' do
          expect(builder_build).to eq ['The master and Margarita', 'Мастер и Маргарита']
        end
      end
    end

    it '.main_title returns both title strings from parallel value' do
      expect(main_title).to eq ['The master and Margarita', 'Мастер и Маргарита']
    end

    it '.full_title returns both title strings from parallel value' do
      expect(full_title).to eq ['The master and Margarita', 'Мастер и Маргарита']
    end

    it '.additional_titles returns empty array' do
      expect(additional_titles).to eq []
    end
  end

  context 'with single untyped title with simple value' do
    # Select (only) value; status primary may or may not be present
    let(:titles) do
      [
        { value: 'Simple untyped' }
      ]
    end

    it '.main_title contains title' do
      expect(main_title).to eq ['Simple untyped']
    end

    it '.full_title contains title' do
      expect(full_title).to eq ['Simple untyped']
    end

    it '.additional_titles is empty array' do
      expect(additional_titles).to eq []
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns the title' do
          expect(builder_build).to eq('Simple untyped')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns single title string' do
          expect(builder_build).to eq('Simple untyped')
        end
      end
    end
  end

  context 'with single typed title with simple value' do
    # Select (only) value; status primary may or may not be present
    let(:titles) do
      [
        {
          value: 'Simple typed',
          type: 'translated'
        }
      ]
    end

    it '.main_title contains title' do
      expect(main_title).to eq ['Simple typed']
    end

    it '.full_title contains title' do
      expect(full_title).to eq ['Simple typed']
    end

    it '.additional_titles is empty array' do
      expect(additional_titles).to eq []
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns the title' do
          expect(builder_build).to eq('Simple typed')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns single title string' do
          expect(builder_build).to eq('Simple typed')
        end
      end
    end
  end

  context 'with space/punctuation/space ending simple value' do
    # strip one or more instances of .,;:/\ or whitespace at beginning or end of string
    let(:titles) do
      [{ value: 'Trailing / ' }]
    end

    it '.main_title strips trailing whitespace or punctuation of .,;:/\ ' do # rubocop:disable RSpec/ExcessiveDocstringSpacing
      expect(main_title).to eq ['Trailing']
    end

    it '.full_title strips trailing whitespace or punctuation of .,;:/\ ' do # rubocop:disable RSpec/ExcessiveDocstringSpacing
      expect(full_title).to eq ['Trailing']
    end

    describe '.build' do
      context 'with add_punctuation true' do
        it 'strips punctuation' do
          expect(builder_build).to eq('Trailing')
        end
      end

      context 'with add_punctuation false' do
        let(:add_punctuation) { true }

        it 'strips punctuation' do
          expect(builder_build).to eq('Trailing')
        end
      end
    end
  end

  context 'with multiple untyped titles with simple values, none primary' do
    let(:titles) do
      [
        { value: 'However am I going to be' },
        { value: 'A second title' }
      ]
    end

    it '.main_title contains first title' do
      expect(main_title).to eq ['However am I going to be']
    end

    it '.full_title contains first title' do
      expect(full_title).to eq ['However am I going to be']
    end

    it '.additional_titles contains second title' do
      expect(additional_titles).to eq ['A second title']
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns the first title' do
          expect(builder_build).to eq('However am I going to be')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns an array with each title string' do
          expect(builder_build).to eq(['However am I going to be', 'A second title'])
        end
      end
    end
  end

  context 'with multiple untyped titles, last one status primary' do
    # Select primary
    let(:titles) do
      [
        { value: 'Not Primary' },
        { value: 'Primary Title', status: 'primary' }
      ]
    end

    it '.main_title contains primary title' do
      expect(main_title).to eq ['Primary Title']
    end

    it '.full_title contains primary title' do
      expect(full_title).to eq ['Primary Title']
    end

    it '.additional_titles contains non-primary title' do
      expect(additional_titles).to eq ['Not Primary']
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns the first title' do
          expect(builder_build).to eq('Primary Title')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns an array with each title string' do
          expect(builder_build).to eq(['Not Primary', 'Primary Title'])
        end
      end
    end
  end

  context 'with multiple typed and untyped titles, one primary' do
    # Select first without type
    let(:titles) do
      [
        {
          value: 'Not Primary'
        },
        {
          value: 'Primary Title',
          type: 'translated',
          status: 'primary'
        }
      ]
    end

    it '.main_title contains primary title' do
      expect(main_title).to eq ['Primary Title']
    end

    it '.full_title contains primary title' do
      expect(full_title).to eq ['Primary Title']
    end

    it '.additional_titles contains non-primary title' do
      expect(additional_titles).to eq ['Not Primary']
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns the first title' do
          expect(builder_build).to eq('Primary Title')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns an array with each title string' do
          expect(builder_build).to eq(['Not Primary', 'Primary Title'])
        end
      end
    end
  end

  context 'with multiple typed and untyped titles, none primary' do
    # Select first without type
    let(:titles) do
      [
        {
          value: 'Title 1',
          type: 'alternative'
        },
        {
          value: 'Title 2'
        },
        {
          value: 'Title 3'
        }
      ]
    end

    it '.main_title contains first value without type' do
      expect(main_title).to eq ['Title 2']
    end

    it '.full_title contains first value without type' do
      expect(full_title).to eq ['Title 2']
    end

    it '.additional_titles contains the other values' do
      expect(additional_titles).to eq ['Title 1', 'Title 3']
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns the first value without type' do
          expect(builder_build).to eq('Title 2')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns an array with each title string' do
          expect(builder_build).to eq(['Title 1', 'Title 2', 'Title 3'])
        end
      end
    end
  end

  context 'with multiple typed titles, one primary' do
    # Select primary
    let(:titles) do
      [
        {
          value: 'Not Primary',
          type: 'alternative'
        },
        {
          value: 'Primary Title',
          type: 'translated',
          status: 'primary'
        }
      ]
    end

    it '.main_title contains primary title' do
      expect(main_title).to eq ['Primary Title']
    end

    it '.full_title contains primary title' do
      expect(full_title).to eq ['Primary Title']
    end

    it '.additional_titles contains non-primary title' do
      expect(additional_titles).to eq ['Not Primary']
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns the first title' do
          expect(builder_build).to eq('Primary Title')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns an array with each title string' do
          expect(builder_build).to eq(['Not Primary', 'Primary Title'])
        end
      end
    end
  end

  context 'with multiple typed titles, none primary' do
    # Select first
    let(:titles) do
      [
        {
          value: 'Title 1',
          type: 'translated'
        },
        {
          value: 'Title 2',
          type: 'alternative'
        }
      ]
    end

    it '.main_title contains first title' do
      expect(main_title).to eq ['Title 1']
    end

    it '.full_title contains first title' do
      expect(full_title).to eq ['Title 1']
    end

    it '.additional_titles contains second title' do
      expect(additional_titles).to eq ['Title 2']
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns the first title' do
          expect(builder_build).to eq('Title 1')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns an array with each title string' do
          expect(builder_build).to eq(['Title 1', 'Title 2'])
        end
      end
    end
  end

  context 'with untyped title ending with space then trailing punctuation' do
    let(:titles) do
      [
        { value: 'Rosie the dog /' }
      ]
    end

    it '.main_title ends before the space' do
      expect(main_title).to eq ['Rosie the dog']
    end

    it '.full_title ends before the space' do
      expect(full_title).to eq ['Rosie the dog']
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns value up to the space' do
          expect(builder_build).to eq('Rosie the dog')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns single string value up to the space' do
          expect(builder_build).to eq('Rosie the dog')
        end
      end
    end
  end

  context 'with a main title (without structuredValue)' do
    let(:titles) do
      [
        # NOTE:  these should be in a structuredValue; because they are not, we get weird results
        { value: 'zee subtitle', type: 'subtitle' },
        { value: 'zer main title', type: 'main title' }
      ]
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns the first title' do
          expect(builder_build).to eq('zee subtitle')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns the main title' do
          expect(builder_build).to eq(['zee subtitle', 'zer main title'])
        end
      end
    end

    it '.main_title is first value (weird due to lack of structuredValue)' do
      expect(main_title).to eq ['zee subtitle']
    end

    it '.full_title is first value (weird due to lack of structuredValue)' do
      expect(full_title).to eq ['zee subtitle']
    end

    it 'additional_titles is second value (weird due to lack of structuredValue)' do
      expect(additional_titles).to eq ['zer main title']
    end
  end

  # ----- structuredValue tests -----

  context 'with structuredValue with all parts in common order' do
    # from a spreadsheet upload integration test
    #   https://argo-stage.stanford.edu/view/sk561pf3505
    let(:titles) do
      [
        structuredValue: [
          {
            value: 'A',
            type: 'nonsorting characters'
          },
          {
            value: 'title',
            type: 'main title'
          },
          {
            value: 'a subtitle',
            type: 'subtitle'
          },
          {
            value: 'Vol. 1',
            type: 'part number'
          },
          {
            value: 'Supplement',
            type: 'part name'
          }
        ]
      ]
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns the reconstructed title with punctuation' do
          expect(builder_build).to eq('A title : a subtitle. Vol. 1, Supplement')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns the reconstructed title with punctuation (as a String)' do
          expect(builder_build).to eq('A title : a subtitle. Vol. 1, Supplement')
        end
      end
    end

    it '.main_title returns the main title with nonsorting characters' do
      expect(main_title).to eq ['A title']
    end

    it '.full_title returns the reconstructed title without punctuation' do
      expect(full_title).to eq ['A title a subtitle Vol. 1 Supplement']
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
    end
  end

  context 'with nested structuredValues' do
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

    it '.build returns the reconstructed nested structuredValue' do
      expect(builder_build).to eq 'brisk junket ti1:nonSort'
    end

    it '.main_title returns the (first) main title with nonsorting characters' do
      expect(main_title).to eq ['brisk junket ti1:nonSort']
    end

    it '.full_title returns the reconstructed nested structuredValue' do
      expect(full_title).to eq ['brisk junket ti1:nonSort']
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
    end
  end

  context 'with structuredValue with associated name note for uniform title' do
    # Omit author name from title
    let(:titles) do
      [
        {
          value: 'Title',
          type: 'uniform',
          note: [
            {
              value: 'Author, An',
              type: 'associated name'
            }
          ]
        }
      ]
    end

    it '.main_title returns the simple value' do
      expect(main_title).to eq ['Title']
    end

    it '.full_title returns the simple value' do
      expect(full_title).to eq ['Title']
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
    end

    it '.build returns the simple value' do
      expect(builder_build).to eq('Title')
    end
  end

  context 'with the structuredValue has part name and part number only' do
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

    describe '.build' do
      context 'with add punctuation is default true' do
        it 'returns the reconstructed value with punctuation' do
          expect(builder_build).to eq('ti1:partNumber, ti1:partName')
        end
      end

      context 'with add punctuation is false' do
        let(:add_punctuation) { false }

        it 'returns the reconstructed value without punctuation' do
          expect(builder_build).to eq('ti1:partNumber ti1:partName')
        end
      end
    end

    # FIXME: should it not return the part name and number?
    it '.main_title returns an empty Array' do
      expect(main_title).to eq []
    end

    it '.full_title returns the reconstructed structuredValue without punctuation' do
      expect(full_title).to eq ['ti1:partNumber ti1:partName']
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
    end
  end

  context 'with structuredValue with subtitle' do
    let(:titles) do
      [
        structuredValue: [
          {
            value: 'A starting subtitle',
            type: 'subtitle'
          },
          {
            value: 'A following title',
            type: 'title'
          }
        ]
      ]
    end

    it '.main_title returns the value for type "title"' do
      expect(main_title).to eq ['A following title']
    end

    it '.full_title returns the reconstructed structuredValue without punctuation' do
      expect(full_title).to eq ['A starting subtitle A following title']
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
    end

    describe '.build' do
      context 'with add punctuation is default (true)' do
        it 'returns the reconstructed structuredValue' do
          expect(builder_build).to eq('A starting subtitleA following title')
        end
      end

      context 'with add punctuation is false' do
        let(:add_punctuation) { false }

        it 'returns the structuredValue without punctuation' do
          expect(builder_build).to eq('A starting subtitle A following title')
        end
      end
    end
  end

  context 'with structuredValue only has subtitle' do
    let(:titles) do
      [
        {
          structuredValue: [
            {
              value: 'subtitle value',
              type: 'subtitle'
            }
          ]
        }
      ]
    end

    it '.main_title has no value' do
      expect(main_title).to eq []
    end

    it '.full_title returns the subtitle value' do
      expect(full_title).to eq ['subtitle value']
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
    end

    it '.build returns the subtitle value' do
      expect(builder_build).to eq('subtitle value')
    end
  end

  context 'with structuredValue is subtitle, part name, part number' do
    let(:titles) do
      [
        {
          structuredValue: [
            {
              value: 'Nothing',
              type: 'subtitle'
            },
            {
              value: 'Series 666',
              type: 'part name'
            },
            {
              value: 'Vol. 1',
              type: 'part number'
            }
          ]
        }
      ]
    end

    it '.main_title has no value' do
      expect(main_title).to eq []
    end

    it '.full_title returns the reconstructed title pieces without added punctuation' do
      expect(full_title).to eq ['Nothing Series 666 Vol. 1']
    end

    it '.build returns the reconstructed value with punctuation' do
      expect(builder_build).to eq('Nothing. Series 666, Vol. 1')
    end
  end

  context 'with structuredValue with multiple subtitles' do
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
      expect(main_title).to eq ['A Title']
    end

    it '.full_title returns value for type "title" without punctuation' do
      expect(full_title).to eq ['The first subtitle The second subtitle A Title']
    end

    it '.additional_titles is empty as there is only one title' do
      expect(additional_titles).to eq []
    end

    describe '.build' do
      context 'with add punctuation is true (default)' do
        it 'returns the reconstructed structuredValue with punctuation' do
          expect(builder_build).to eq('The first subtitle : The second subtitleA Title')
        end
      end

      context 'with add punctuation is false' do
        let(:add_punctuation) { false }

        it 'returns the reconstructed structuredValue without punctuation' do
          expect(builder_build).to eq('The first subtitle The second subtitle A Title')
        end
      end
    end
  end

  context 'with structuredValue with parts in uncommon order' do
    # it uses field order given, unlike stanford_mods
    # based on ckey 9803970
    let(:titles) do
      [
        {
          structuredValue: [
            {
              value: 'The',
              type: 'nonsorting characters'
            },
            {
              value: 'title',
              type: 'main title'
            },
            {
              value: 'Vol. 1',
              type: 'part number'
            },
            {
              value: 'Supplement',
              type: 'part name'
            },
            {
              value: 'a subtitle',
              type: 'subtitle'
            }
          ]
        }
      ]
    end

    it '.main_title is nonsorting plus main title' do
      expect(main_title).to eq ['The title']
    end

    it '.full_title respects order of occurrence (no punctuation)' do
      expect(full_title).to eq ['The title Vol. 1 Supplement a subtitle']
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'uses correct punctuation and respects order of occurrence' do
          expect(builder_build).to eq('The title. Vol. 1, Supplement : a subtitle')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns String using correct punctuation and respects order of occurrence' do
          expect(builder_build).to eq('The title. Vol. 1, Supplement : a subtitle')
        end
      end
    end
  end

  context 'with structuredValue with non-sorting not first' do
    let(:titles) do
      [
        structuredValue: [
          {
            value: 'Series 1',
            type: 'part number'
          },
          {
            value: 'A',
            type: 'nonsorting characters'
          },
          {
            value: 'Vinsky',
            type: 'main title'
          }
        ]
      ]
    end

    it '.main_title respects order of occurrence (and ignores part number)' do
      expect(main_title).to eq ['A Vinsky']
    end

    it '.full_title respects order of occurrence (no punctuation)' do
      expect(full_title).to eq ['Series 1 A Vinsky']
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'uses correct punctuation and respects order of occurrence' do
          expect(builder_build).to eq('Series 1. A Vinsky')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns String using correct punctuation and respects order of occurrence' do
          expect(builder_build).to eq('Series 1. A Vinsky')
        end
      end
    end
  end

  context 'with structuredValue with multiple partName' do
    # it uses field order given, unlike stanford_mods
    let(:titles) do
      [
        {
          structuredValue: [
            {
              value: 'Title',
              type: 'main title'
            },
            {
              value: 'Special series',
              type: 'part name'
            },
            {
              value: 'Vol. 1',
              type: 'part number'
            },
            {
              value: 'Supplement',
              type: 'part name'
            }
          ]
        }
      ]
    end

    it '.main_title is main title' do
      expect(main_title).to eq ['Title']
    end

    it '.full_title respects order of occurrence (no punctuation)' do
      expect(full_title).to eq ['Title Special series Vol. 1 Supplement']
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'uses correct punctuation and respects order of occurrence' do
          expect(builder_build).to eq('Title. Special series, Vol. 1, Supplement')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns String using correct punctuation and respects order of occurrence' do
          expect(builder_build).to eq('Title. Special series, Vol. 1, Supplement')
        end
      end
    end
  end

  context 'with structuredValue with part before title' do
    # it uses field order given, unlike stanford_mods
    let(:titles) do
      [
        {
          structuredValue: [
            {
              value: 'Series 1',
              type: 'part number'
            },
            {
              value: 'Title',
              type: 'main title'
            }
          ]
        }
      ]
    end

    it '.main_title is main title' do
      expect(main_title).to eq ['Title']
    end

    it '.full_title respects order of occurrence (no punctuation)' do
      expect(full_title).to eq ['Series 1 Title']
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'uses correct punctuation and respects order of occurrence' do
          expect(builder_build).to eq('Series 1. Title')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns String using correct punctuation and respects order of occurrence' do
          expect(builder_build).to eq('Series 1. Title')
        end
      end
    end
  end

  context 'with structuredValue parts beginning/ending with space/punctuation/space' do
    # strip one or more instances of .,;:/\ plus whitespace at beginning or end of string
    let(:titles) do
      [
        {
          structuredValue: [
            {
              value: 'Title.',
              type: 'main title'
            },
            {
              value: ':subtitle ',
              type: 'subtitle'
            }
          ]
        }
      ]
    end

    it '.main_title strips whitespace or punctuation of .,;:/\ from main title' do
      expect(main_title).to eq ['Title']
    end

    it '.full_title strips whitespace or punctuation of .,;:/\ from values' do
      expect(full_title).to eq ['Title subtitle']
    end

    describe '.build' do
      context 'with add_punctuation true' do
        it 'strips punctuation in values and adds combining punctuation' do
          expect(builder_build).to eq('Title : subtitle')
        end
      end

      context 'with add_punctuation false' do
        let(:add_punctuation) { false }

        it 'strips punctuation in values' do
          expect(builder_build).to eq('Title subtitle')
        end
      end
    end
  end

  # nonsorting characters value is followed by a space, unless the nonsorting
  #   character count note has a numeric value equal to the length of the
  #   nonsorting characters value, in which case no space is inserted
  # subtitle is preceded by space colon space, unless it is at the beginning
  #   of the title string
  # partName and partNumber are always separated from each other by comma space
  # first partName or partNumber in the string is preceded by period space
  # partName or partNumber before nonsorting characters or main title is followed
  #   by period space
  context 'with nonsorting characters with count note' do
    # it does not force a space separator, unlike stanford_mods
    let(:titles) do
      [
        {
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
        }
      ]
    end

    describe '.build' do
      context 'with add punctuation is default (true)' do
        it 'returns the title with (count) non sorting characters included' do
          expect(builder_build).to eq('The  means to prosperity')
        end
      end

      context 'with add punctuation is false' do
        let(:add_punctuation) { false }

        it 'returns the title with (count) non sorting characters included' do
          expect(builder_build).to eq('The  means to prosperity')
        end
      end
    end

    it '.main_title returns the title with (count) non sorting characters included' do
      expect(main_title).to eq ['The means to prosperity']
    end

    it '.full_title returns the title with (count) non sorting characters included' do
      expect(full_title).to eq ['The  means to prosperity']
    end
  end

  context 'with nonsorting characters without count note' do
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
      expect(main_title).to eq ['The means to prosperity']
    end

    it '.full_title returns the title with non sorting characters included' do
      expect(full_title).to eq ['The means to prosperity']
    end
  end

  context 'with nonsorting characters ends in dash, without count note' do
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

    describe '.build' do
      context 'with add punctuation is default (true)' do
        it 'returns the title with non sorting characters included, no space' do
          expect(builder_build).to eq('The-means to prosperity')
        end
      end

      context 'with add punctuation is false' do
        let(:add_punctuation) { false }

        it 'returns the title with non sorting characters included, no space' do
          expect(builder_build).to eq('The-means to prosperity')
        end
      end
    end

    it '.main_title returns the title with non sorting characters included' do
      expect(main_title).to eq ['The-means to prosperity']
    end

    it '.full_title returns the title with non sorting characters included' do
      expect(full_title).to eq ['The-means to prosperity']
    end
  end

  context 'with nonsorting characters ends in apostrophe, without count note' do
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
      expect(main_title).to eq ['L\'means to prosperity']
    end

    it '.full_title returns the title with non sorting characters included' do
      expect(full_title).to eq ['L\'means to prosperity']
    end
  end

  # ----- parallelValue tests -----

  context 'with parallelValue with status primary on one value' do
    # Select primary
    let(:titles) do
      [
        {
          parallelValue: [
            {
              value: 'Not Primary'
            },
            {
              value: 'Primary Value',
              status: 'primary'
            }
          ]
        }
      ]
    end

    describe '.build' do
      context 'with strategy first' do
        it 'returns value with primary status from parallel value' do
          expect(builder_build).to eq 'Primary Value'
        end
      end

      context 'with strategy all' do
        let(:strategy) { :all }

        it 'returns all parallel values' do
          expect(builder_build).to eq ['Not Primary', 'Primary Value']
        end
      end
    end

    it '.main_title returns primary value' do
      expect(main_title).to eq ['Primary Value']
    end

    it '.full_title returns both values as there is only one top level title' do
      expect(full_title).to eq ['Not Primary', 'Primary Value']
    end

    it '.additional_titles returns empty array as there is only one title' do
      expect(additional_titles).to eq []
    end
  end

  context 'with parallelValue of status primary' do
    let(:titles) do
      [
        {
          parallelValue: [
            { value: 'First' },
            { value: 'Second' }
          ],
          status: 'primary'
        }
      ]
    end

    describe '.build' do
      # For display, select first value in primary parallelValue
      context 'with strategy first' do
        it 'returns first parallel value' do
          expect(builder_build).to eq 'First'
        end
      end

      context 'with strategy all' do
        let(:strategy) { :all }

        it 'returns all parallel values' do
          expect(builder_build).to eq %w[First Second]
        end
      end
    end

    it '.main_title returns both values there is only one top level title' do
      expect(main_title).to eq %w[First Second]
    end

    it '.full_title returns both values as there is only one top level title' do
      expect(full_title).to eq %w[First Second]
    end

    it '.additional_titles returns empty array as there is only one title' do
      expect(additional_titles).to eq []
    end
  end

  context 'with parallelValue of status primary and status primary on one value' do
    let(:titles) do
      [
        {
          parallelValue: [
            {
              value: 'Not Primary'
            },
            {
              value: 'Primary',
              status: 'primary'
            }
          ],
          status: 'primary'
        }
      ]
    end

    describe '.build' do
      context 'with strategy first' do
        # Select primary value in primary parallelValue
        it 'returns value with primary status from parallel value' do
          expect(builder_build).to eq 'Primary'
        end
      end

      context 'with strategy all' do
        let(:strategy) { :all }

        it 'returns all parallel values' do
          expect(builder_build).to eq ['Not Primary', 'Primary']
        end
      end
    end

    it '.main_title returns single value of type primary' do
      expect(main_title).to eq ['Primary']
    end

    it '.full_title returns both values as there is only one top level title' do
      expect(full_title).to eq ['Not Primary', 'Primary']
    end

    it '.additional_titles returns empty array as there is only one title' do
      expect(additional_titles).to eq []
    end
  end

  context 'with primary on both one of a parallelValue and on a simple value' do
    # Select simple value with primary; the parallelValue is not itself the primary title,
    # but one value is primary within the parallelValue
    let(:titles) do
      [
        {
          parallelValue: [
            {
              value: 'Primary Parallel',
              status: 'primary'
            },
            {
              value: 'Ordinary Parallel'
            }
          ]
        },
        {
          value: 'Simple Primary',
          status: 'primary'
        }
      ]
    end

    describe '.build' do
      context 'with strategy first' do
        # Select primary value in primary parallelValue
        it 'returns simple top level value with primary status' do
          expect(builder_build).to eq 'Simple Primary'
        end
      end

      context 'with strategy all' do
        let(:strategy) { :all }

        it 'returns all values' do
          expect(builder_build).to eq ['Primary Parallel', 'Ordinary Parallel', 'Simple Primary']
        end
      end
    end

    it '.main_title returns simple top level value with primary status' do
      expect(main_title).to eq ['Simple Primary']
    end

    it '.full_title returns simple top level value with primary status' do
      expect(full_title).to eq ['Simple Primary']
    end

    it '.additional_titles returns both values of parallelValue as they are not considered primary' do
      expect(additional_titles).to eq ['Primary Parallel', 'Ordinary Parallel']
    end
  end

  context 'with parallelValue (first) and simple value, no primary' do
    # Select first value
    let(:titles) do
      [
        {
          parallelValue: [
            {
              value: 'Parallel 1'
            },
            {
              value: 'Parallel 2'
            }
          ]
        },
        {
          value: 'Simple'
        }
      ]
    end

    describe '.build' do
      context 'with strategy first' do
        it 'returns first value of parallelValue (which is first)' do
          expect(builder_build).to eq 'Parallel 1'
        end
      end

      context 'with strategy all' do
        let(:strategy) { :all }

        it 'returns all values' do
          expect(builder_build).to eq ['Parallel 1', 'Parallel 2', 'Simple']
        end
      end
    end

    it '.main_title returns both values of parallelValue (which is first)' do
      expect(main_title).to eq ['Parallel 1', 'Parallel 2']
    end

    it '.full_title returns both values of parallelValue (which is first)' do
      expect(full_title).to eq ['Parallel 1', 'Parallel 2']
    end

    it '.additional_titles returns simple value (which is second)' do
      expect(additional_titles).to eq ['Simple']
    end
  end

  context 'with parallelValue with additional value, value first, no primary' do
    # Select first value
    let(:titles) do
      [
        { value: 'Simple' },
        {
          parallelValue: [
            { value: 'Parallel 1' },
            { value: 'Parallel 2' }
          ]
        }
      ]
    end

    describe '.build' do
      context 'with strategy first' do
        it 'returns first value' do
          expect(builder_build).to eq 'Simple'
        end
      end

      context 'with strategy all' do
        let(:strategy) { :all }

        it 'returns all values' do
          expect(builder_build).to eq ['Simple', 'Parallel 1', 'Parallel 2']
        end
      end
    end

    it '.main_title returns first value' do
      expect(main_title).to eq ['Simple']
    end

    it '.full_title returns first value' do
      expect(full_title).to eq ['Simple']
    end

    it '.additional_titles returns simple value (which is second)' do
      expect(additional_titles).to eq ['Parallel 1', 'Parallel 2']
    end
  end

  context 'with parallelValue, one of type subtitle' do
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

    describe '.build' do
      context 'with strategy first' do
        it 'returns untyped title string from parallel value' do
          expect(builder_build).to eq 'A Random Title'
        end
      end

      context 'with strategy all' do
        let(:strategy) { :all }

        it 'returns all parallel values' do
          expect(builder_build).to eq ['subtitle', 'A Random Title']
        end
      end
    end

    it '.main_title returns both values' do
      expect(main_title).to eq ['subtitle', 'A Random Title']
    end

    it '.full_title returns both values' do
      expect(full_title).to eq ['subtitle', 'A Random Title']
    end

    it '.additional_titles returns empty array as there is only one title' do
      expect(additional_titles).to eq []
    end
  end

  context 'with multiple titles with parallel values, status primary on half of one parallel value' do
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
      expect(main_title).to eq ['Sefer Bet nadiv']
    end

    it '.full_title is entire value from title with status "primary"' do
      expect(full_title).to eq ['Sefer Bet nadiv sheʼelot u-teshuvot, ḥidushe Torah, derashot', 'hebrew main title hebrew subtitle']
    end

    it '.additional_titles is all but the full_title' do
      # QUESTION:  shouldn't the uniform titles start with the associated name?
      # see https://github.com/sul-dlss/cocina-models/issues/657
      actual_result = additional_titles
      [
        'Bet nadiv', # uniform
        'hebrew uniform value', # uniform
        'Bet nadiv', # alternative
        'hebrew alternative' # alternative
      ].each { |title| expect(actual_result).to include(title) }
      expect(actual_result.size).to eq(4)
    end

    describe '.build' do
      context 'with :first strategy' do
        it 'returns the primary title' do
          expect(builder_build).to eq('Sefer Bet nadiv : sheʼelot u-teshuvot, ḥidushe Torah, derashot')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        # QUESTION:  shouldn't the uniform titles start with the associated name?
        # see https://github.com/sul-dlss/cocina-models/issues/657
        it 'returns an array with each title string' do
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

    it '.main_title is the first untyped title (which is found within the parallel title)' do
      expect(main_title).to eq ['first parallel', 'second parallel']
    end

    it '.full_title is the first untyped title (which is found within the parallel title)' do
      expect(full_title).to eq ['first parallel', 'second parallel']
    end

    it '.additional_titles is all but the full_title' do
      actual_result = additional_titles
      [
        'abbreviated',
        'alternative',
        # 'first parallel',
        # 'second parallel',
        'supplied',
        'translated',
        'transliterated',
        'uniform'
      ].each { |title| expect(actual_result).to include(title) }
      expect(actual_result.size).to eq(6)
    end

    describe '.build' do
      context 'with :first strategy' do
        it '.returns the first untyped title (which is found within the parallel title)' do
          expect(builder_build).to eq('first parallel')
        end
      end

      context 'with :all strategy' do
        let(:strategy) { :all }

        it 'returns an array with each title string' do
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
end
