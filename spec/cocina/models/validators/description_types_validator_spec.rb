# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionTypesValidator do
  let(:validate) { described_class.validate(clazz, props) }

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
    }
  end

  let(:contributor_type) { 'person' }
  let(:contributor_identifier_type) { 'ORCID' }
  let(:related_resource_contributor_type) { 'person' }

  let(:request_desc_props) do
    dro_props.dup.tap do |props|
      props[:description].delete(:purl)
    end
  end

  let(:dro_props) { { description: desc_props } }

  describe 'when a valid Description' do
    it 'does not raise' do
      validate
    end
  end

  describe 'when a valid RequestDescription' do
    let(:props) { request_desc_props }
    let(:clazz) { Cocina::Models::RequestDescription }

    it 'does not raise' do
      validate
    end
  end

  describe 'when a valid DRO' do
    let(:clazz) { Cocina::Models::DRO }
    let(:props) { dro_props }

    it 'does not raise' do
      validate
    end
  end

  describe 'when none of the above' do
    let(:props) { {} }
    let(:clazz) { Cocina::Models::Identification }

    it 'does not raise' do
      validate
    end
  end

  describe 'when an invalid RequestDescription' do
    let(:props) { request_desc_props }
    let(:clazz) { Cocina::Models::RequestDRO }
    let(:contributor_type) { 'foo' }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'when an invalid DRO' do
    let(:clazz) { Cocina::Models::DRO }
    let(:props) { dro_props }
    let(:contributor_type) { 'foo' }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'when an invalid type at top level' do
    let(:contributor_type) { 'foo' }

    it 'raises' do
      expect do
        validate
      end.to raise_error(Cocina::Models::ValidationError, 'Unrecognized types in description: contributor1')
    end
  end

  describe 'when an invalid type at other level' do
    let(:contributor_identifier_type) { 'foo' }

    it 'raises' do
      expect do
        validate
      end.to raise_error(Cocina::Models::ValidationError,
                         'Unrecognized types in description: contributor1.identifier1')
    end
  end

  describe 'when an invalid type at nested level' do
    let(:related_resource_contributor_type) { 'foo' }

    it 'raises' do
      expect do
        validate
      end.to raise_error(Cocina::Models::ValidationError,
                         'Unrecognized types in description: relatedResource1.contributor1')
    end
  end

  describe 'when a case mismatch' do
    let(:contributor_type) { 'PERson' }

    it 'is case insensitive' do
      validate
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
            note: [
              {
                value: 'Stanford University',
                type: 'affiliation'
              },
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
                         'Unrecognized types in description: contributor1.name1.parallelValue1.structuredValue1')
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
end
