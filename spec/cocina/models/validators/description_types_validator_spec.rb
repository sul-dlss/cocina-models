# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionTypesValidator do
  let(:clazz) { Cocina::Models::Description }

  let(:props) { desc_props }

  let(:desc_props) do
    {
      title: [{ value: 'The Structure of Scientific Revolutions' }],
      purl: 'https://purl.stanford.edu/bc123df4567',
      contributor: [
        {
          name: [
            {
              value: 'Kuhn, Thomas'
            }
          ],
          type: contributor_type,
          status: 'primary',
          identifier: [
            {
              value: '0000-0000-0000-0000',
              type: contributor_identifier_type
            }
          ]
        }
      ],
      relatedResource: [
        {
          title: [
            {
              value: 'The Logic of Scientific Discovery'
            }
          ],
          contributor: [
            {
              type: related_resource_contributor_type,
              name: [
                {
                  value: 'Popper, Karl'
                }
              ]
            }
          ],
          type: 'related to'
        }
      ]
    }.with_indifferent_access
  end

  let(:contributor_type) { 'person' }
  let(:contributor_identifier_type) { 'ORCID' }
  let(:related_resource_contributor_type) { 'person' }

  let(:request_desc_props) do
    desc_props.dup.tap do |props|
      props.delete(:purl)
    end
  end

  describe '#validate' do
    let(:validate) { described_class.validate(clazz, props) }

    describe 'when a valid Description' do
      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    describe 'when a valid RequestDescription' do
      let(:props) { request_desc_props }
      let(:clazz) { Cocina::Models::RequestDescription }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    describe 'when an invalid type at top level' do
      let(:contributor_type) { 'foo' }

      it 'raises' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError, 'Unrecognized types in description: contributor1 (foo)')
      end
    end

    describe 'when an invalid type at other level' do
      let(:contributor_identifier_type) { 'foo' }

      it 'raises' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError,
                           'Unrecognized types in description: contributor1.identifier1 (foo)')
      end
    end

    describe 'when an invalid type at nested level' do
      let(:related_resource_contributor_type) { 'foo' }

      it 'raises' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError,
                           'Unrecognized types in description: relatedResource1.contributor1 (foo)')
      end
    end

    describe 'when a case mismatch' do
      let(:contributor_type) { 'PERson' }

      it 'is case insensitive' do
        expect { validate }.not_to raise_error
      end
    end

    describe 'with a parallelValue' do
      let(:desc_props) do
        {
          title: [{ value: 'The Professor: A Sentimental Education' }],
          purl: 'https://purl.stanford.edu/bc123df4567',
          contributor: [
            {
              name: [
                {
                  parallelValue: [
                    {
                      structuredValue: [
                        {
                          value: 'Terry',
                          # This type is invalid
                          type: 'fooname'
                        },
                        {
                          value: 'Castle',
                          type: 'surname'
                        }
                      ]
                    },
                    {
                      value: 'Castle, Terry',
                      type: 'display'
                    }
                  ]
                }
              ],
              status: 'primary',
              type: 'person',
              identifier: [
                {
                  value: 'https://www.wikidata.org/wiki/Q7704207',
                  type: 'Wikidata'
                }
              ],
              affiliation: [
                {
                  value: 'Stanford University'
                }
              ],
              note: [
                {
                  value: 'Professor of English',
                  type: 'description'
                }
              ]
            }
          ]
        }
      end

      it 'ignores parallelValue and raises' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError,
                           'Unrecognized types in description: ' \
                           'contributor1.name1.parallelValue1.structuredValue1 (fooname)')
      end
    end

    describe 'with an invalid parallelEvent' do
      let(:desc_props) do
        {
          title: [
            {
              parallelValue: [
                { value: 'Ṣammamtu an ahwāka yā sayyidī', status: 'primary' },
                { value: 'صممت أن اهواك يا سيدي' }
              ]
            }
          ],
          purl: 'https://purl.stanford.edu/xq000jd3530',
          event: [
            {
              parallelEvent: [
                {
                  note: [
                    { type: 'edition', value: 'al-Ṭabʻah 1.' }
                  ]
                },
                {
                  note: [
                    { type: 'foo', value: 'الطبعة ١.' }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'ignores parallelEvent and raises' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError,
                           'Unrecognized types in description: event1.parallelEvent2.note1 (foo)')
      end
    end

    describe 'with a valid parallelEvent' do
      let(:desc_props) do
        {
          title: [
            {
              parallelValue: [
                { value: 'Ṣammamtu an ahwāka yā sayyidī', status: 'primary' },
                { value: 'صممت أن اهواك يا سيدي' }
              ]
            }
          ],
          purl: 'https://purl.stanford.edu/xq000jd3530',
          event: [
            {
              parallelEvent: [
                {
                  note: [
                    { type: 'edition', value: 'al-Ṭabʻah 1.' }
                  ]
                },
                {
                  note: [
                    { type: 'edition', value: 'الطبعة ١.' }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'ignores parallelEvent and does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    describe 'with an invalid parallelContributor' do
      let(:desc_props) do
        {
          contributor: [
            {
              parallelContributor: [
                {
                  name: [
                    {
                      structuredValue: [
                        {
                          value: 'Li, Yahong',
                          type: 'foo'
                        },
                        {
                          value: '1963-',
                          type: 'life dates'
                        }
                      ]
                    }
                  ]
                },
                {
                  name: [
                    {
                      value: '李亞虹'
                    }
                  ]
                }
              ],
              type: 'person'
            }
          ]
        }
      end

      it 'ignores parallelContributor and raises' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError,
                           'Unrecognized types in description: ' \
                           'contributor1.parallelContributor1.name1.structuredValue1 (foo)')
      end
    end

    describe 'with an valid parallelContributor' do
      let(:desc_props) do
        {
          contributor: [
            {
              parallelContributor: [
                {
                  name: [
                    {
                      structuredValue: [
                        {
                          value: 'Li, Yahong',
                          type: 'name'
                        },
                        {
                          value: '1963-',
                          type: 'life dates'
                        }
                      ]
                    }
                  ]
                },
                {
                  name: [
                    {
                      value: '李亞虹'
                    }
                  ]
                }
              ],
              type: 'person'
            }
          ]
        }
      end

      it 'ignores parallelContributor and does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    describe 'with a nested structuredValue' do
      let(:desc_props) do
        {
          title: [{ value: 'Leon Kolb collection of portraits' }],
          purl: 'https://purl.stanford.edu/rr239pp1335',
          subject: [
            {
              structuredValue: [
                {
                  parallelValue: [
                    {
                      structuredValue: [
                        {
                          value: 'Andrada',
                          type: 'surname'
                        },
                        {
                          value: 'Leitao, Francisco d\'',
                          type: 'fooname'
                        },
                        {
                          value: '17th C.',
                          type: 'life dates'
                        }
                      ]
                    },
                    {
                      value: 'Andrada, Leitao, Francisco d\', 17th C.',
                      type: 'display'
                    }
                  ],
                  type: 'person',
                  note: [
                    {
                      value: 'Depicted',
                      type: 'role',
                      code: 'dpc',
                      uri: 'http://id.loc.gov/vocabulary/relators/dpc',
                      source: {
                        code: 'marcrelator',
                        uri: 'http://id.loc.gov/vocabulary/relators/'
                      }
                    }
                  ]
                },
                {
                  value: 'Pictorial works',
                  type: 'topic'
                }
              ]
            }
          ]
        }
      end

      it 'ignores nesting and raises' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'when description_types.yml has value with special character' do
      let(:desc_props) do
        {
          title: [{ value: 'Testing West Mat #' }],
          purl: 'https://purl.stanford.edu/bc123df4567',
          identifier: [
            {
              value: '123',
              type: 'West Mat #'
            }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end
  end

  describe '#meets_preconditions?' do
    let(:validator) { described_class.new(clazz, props) }

    let(:meets_preconditions) { validator.send(:meets_preconditions?) }

    context 'when RequestDescription' do
      let(:clazz) { Cocina::Models::RequestDescription }

      it 'meets preconditions' do
        expect(meets_preconditions).to be true
      end
    end

    context 'when Description' do
      let(:clazz) { Cocina::Models::Description }

      it 'meets preconditions' do
        expect(meets_preconditions).to be true
      end
    end

    context 'when DRO' do
      let(:clazz) { Cocina::Models::DRO }

      it 'does not meet preconditions' do
        expect(meets_preconditions).to be false
      end
    end
  end
end
