# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Builders::NameTitleGroupBuilder do
  describe '#build_title_values_to_contributor_name_values' do
    let(:title) { Cocina::Models::Title.new(props) }
    let(:title_to_name) { described_class.build_title_values_to_contributor_name_values(title) }

    context 'when basic example' do
      let(:props) do
        {
          value: 'A title',
          type: 'uniform',
          note: [
            {
              value: 'Smith, John',
              type: 'associated name'
            }
          ]
        }
      end

      it 'returns map' do
        expect(title_to_name).to eq({ { value: 'A title' } => { value: 'Smith, John' } })
      end
    end

    context 'when no associated name note' do
      let(:props) do
        {
          value: 'A title',
          type: 'uniform'
        }
      end

      it 'returns empty map' do
        expect(title_to_name).to eq({})
      end
    end

    context 'when uniform title with authority' do
      let(:props) do
        {
          value: 'Hamlet',
          type: 'uniform',
          source: {
            uri: 'http://id.loc.gov/authorities/names/',
            code: 'naf'
          },
          uri: 'http://id.loc.gov/authorities/names/n80008522',
          note: [
            {
              value: 'Shakespeare, William, 1564-1616',
              type: 'associated name'
            }
          ]
        }
      end

      it 'returns map' do
        expect(title_to_name).to eq({ value: 'Hamlet' } => { value: 'Shakespeare, William, 1564-1616' })
      end
    end

    context 'when uniform title with multipart name' do
      let(:props) do
        {
          structuredValue: [
            {
              value: 'Ballades, piano',
              type: 'main title'
            },
            {
              value: 'no. 3, op. 47, A♭ major',
              type: 'part number'
            }
          ],
          type: 'uniform',
          note: [
            {
              structuredValue: [
                {
                  value: 'Chopin, Frédéric',
                  type: 'name'
                },
                {
                  value: '1810-1849',
                  type: 'life dates'
                }
              ],
              type: 'associated name'
            }
          ]
        }
      end

      it 'returns map' do
        expect(title_to_name).to eq({ structuredValue: [
                                      {
                                        structuredValue: [],
                                        parallelValue: [],
                                        groupedValue: [],
                                        value: 'Ballades, piano',
                                        type: 'main title',
                                        identifier: [],
                                        note: [],
                                        appliesTo: []
                                      }, {
                                        structuredValue: [],
                                        parallelValue: [],
                                        groupedValue: [],
                                        value: 'no. 3, op. 47, A♭ major',
                                        type: 'part number',
                                        identifier: [],
                                        note: [],
                                        appliesTo: []
                                      }
                                    ] } => {
                                      structuredValue: [
                                        {
                                          structuredValue: [],
                                          parallelValue: [],
                                          groupedValue: [],
                                          value: 'Chopin, Frédéric',
                                          type: 'name',
                                          identifier: [],
                                          note: [],
                                          appliesTo: []
                                        },
                                        {
                                          structuredValue: [],
                                          parallelValue: [],
                                          groupedValue: [],
                                          value: '1810-1849',
                                          type: 'life dates',
                                          identifier: [],
                                          note: [],
                                          appliesTo: []
                                        }
                                      ]
                                    })
      end
    end

    context 'when parallel uniform title' do
      let(:props) do
        {
          parallelValue: [
            {
              value: 'Mishnah berurah. English',
              note: [
                {
                  structuredValue: [
                    {
                      value: 'Israel Meir',
                      type: 'name'
                    },
                    {
                      value: 'ha-Kohen',
                      type: 'term of address'
                    }
                  ],
                  type: 'associated name'
                }
              ]
            },
            {
              value: 'Mishnah berurah in Hebrew characters',
              note: [
                {
                  structuredValue: [
                    {
                      value: 'Israel Meir in Hebrew characters',
                      type: 'name'
                    },
                    {
                      value: '1838-1933',
                      type: 'life dates'
                    }
                  ],
                  type: 'associated name'
                }
              ]
            }
          ],
          type: 'uniform'
        }
      end

      it 'returns map' do
        expect(title_to_name).to eq({ value: 'Mishnah berurah. English' } => {
                                      structuredValue: [
                                        {
                                          structuredValue: [],
                                          parallelValue: [],
                                          groupedValue: [],
                                          value: 'Israel Meir',
                                          type: 'name',
                                          identifier: [],
                                          note: [],
                                          appliesTo: []
                                        },
                                        {
                                          structuredValue: [],
                                          parallelValue: [],
                                          groupedValue: [],
                                          value: 'ha-Kohen',
                                          type: 'term of address',
                                          identifier: [],
                                          note: [],
                                          appliesTo: []
                                        }
                                      ]
                                    },
                                    { value: 'Mishnah berurah in Hebrew characters' } => {
                                      structuredValue: [
                                        {
                                          structuredValue: [],
                                          parallelValue: [],
                                          groupedValue: [],
                                          value: 'Israel Meir in Hebrew characters',
                                          type: 'name',
                                          identifier: [],
                                          note: [],
                                          appliesTo: []
                                        },
                                        {
                                          structuredValue: [],
                                          parallelValue: [],
                                          groupedValue: [],
                                          value: '1838-1933',
                                          type: 'life dates',
                                          identifier: [],
                                          note: [],
                                          appliesTo: []
                                        }
                                      ]
                                    })
      end
    end
  end

  describe '#contributor_for_contributor_name_value_slice' do
    let(:actual_contributor) do
      described_class.contributor_for_contributor_name_value_slice(
        contributor_name_value_slice: contributor_slice,
        contributors: [contributor]
      )
    end
    let(:contributor) { Cocina::Models::Contributor.new(props) }

    context 'when basic example' do
      let(:props) do
        {
          name: [
            { value: 'Smith, John' },
            { value: 'Smith, Jane' }
          ]
        }
      end

      let(:contributor_slice) { { value: 'Smith, John' } }

      it 'returns Contributor' do
        expect(actual_contributor).to eq(contributor)
      end
    end

    context 'when no match' do
      let(:props) do
        {
          name: [
            { value: 'Smith, John' }
          ]
        }
      end

      let(:contributor_slice) { { value: 'not Smith, John' } }

      it 'returns nil' do
        expect(actual_contributor).to be_nil
      end
    end

    context 'when contributor with authority' do
      let(:props) do
        {
          name: [
            {
              value: 'Shakespeare, William, 1564-1616',
              uri: 'http://id.loc.gov/authorities/names/n78095332',
              source: {
                uri: 'http://id.loc.gov/authorities/names/',
                code: 'naf'
              }
            }
          ],
          status: 'primary',
          type: 'person'
        }
      end

      let(:contributor_slice) { { value: 'Shakespeare, William, 1564-1616' } }

      it 'returns Contributor' do
        expect(actual_contributor).to eq(contributor)
      end
    end

    context 'when contributor with multipart name' do
      let(:props) do
        {
          name: [
            {
              structuredValue: [
                {
                  value: 'Chopin, Frédéric',
                  type: 'name'
                },
                {
                  value: '1810-1849',
                  type: 'life dates'
                }
              ]
            }
          ],
          status: 'primary',
          type: 'person',
          role: [
            {
              value: 'composer'
            }
          ]
        }
      end

      let(:contributor_slice) do
        {
          structuredValue: [
            {
              structuredValue: [],
              parallelValue: [],
              groupedValue: [],
              value: 'Chopin, Frédéric',
              type: 'name',
              identifier: [],
              note: [],
              appliesTo: []
            },
            {
              structuredValue: [],
              parallelValue: [],
              groupedValue: [],
              value: '1810-1849',
              type: 'life dates',
              identifier: [],
              note: [],
              appliesTo: []
            }
          ]
        }
      end

      it 'returns Contributor' do
        expect(actual_contributor).to eq(contributor)
      end
    end

    context 'when parallel contributor' do
      let(:props) do
        {
          name: [
            {
              parallelValue: [
                {
                  structuredValue: [
                    {
                      value: 'Israel Meir',
                      type: 'name'
                    },
                    {
                      value: 'ha-Kohen',
                      type: 'term of address'
                    }
                  ],
                  status: 'primary'
                },
                {
                  structuredValue: [
                    {
                      value: 'Israel Meir in Hebrew characters',
                      type: 'name'
                    },
                    {
                      value: '1838-1933',
                      type: 'life dates'
                    }
                  ]
                }
              ]
            }
          ],
          type: 'person',
          status: 'primary'
        }
      end

      let(:contributor_slice) do
        {
          structuredValue: [
            {
              structuredValue: [],
              parallelValue: [],
              groupedValue: [],
              value: 'Israel Meir',
              type: 'name',
              identifier: [],
              note: [],
              appliesTo: []
            },
            {
              structuredValue: [],
              parallelValue: [],
              groupedValue: [],
              value: 'ha-Kohen',
              type: 'term of address',
              identifier: [],
              note: [],
              appliesTo: []
            }
          ]
        }
      end

      it 'returns Contributor' do
        expect(actual_contributor).to eq(contributor)
      end
    end
  end
end
