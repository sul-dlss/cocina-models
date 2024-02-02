# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionValuesValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:props) { desc_props.with_indifferent_access }
  let(:desc_props) do
    {
      title: [
        { value: 'A title' },
        { parallelValue: [{ value: 'A title' }, { value: 'Another title' }] },
        { groupedValue: [{ value: 'A title' }, { value: 'Another title' }] },
        { structuredValue: [{ value: 'A title', type: 'main title' }, { value: 'Another title', type: 'subtitle' }] },
        { valueAt: 'abc123' }
      ],
      purl: 'https://purl.stanford.edu/bc123df4567',
      relatedResource: [
        {
          title: [
            { value: 'A related title' },
            { structuredValue: [{ value: 'A related title', type: 'main title' }]}
          ],
          type: 'related to'
        }
      ]
    }
  end

  describe '#validate' do
    let(:validate) { described_class.validate(clazz, props) }

    let(:invalid_desc_props) do
      {
        title: [
          {
            value: 'A title',
            parallelValue: [{ value: 'A title' }, { value: 'Another title' }]
          }
        ],
        purl: 'https://purl.stanford.edu/bc123df4567',
        relatedResource: [
          {
            title: [
              {
                groupedValue: [{ value: 'A title' }, { value: 'Another title' }],
                structuredValue: [{ value: 'A title' }, { value: 'Another title' }]
              }
            ],
            type: 'related to'
          }
        ]
      }
    end

    let(:blank_title_props) do
      {
        title: [
          {
            value: ' ',
            parallelValue: [{ value: 'A title' }, { value: 'Another title' }]
          }
        ]
      }
    end

    let(:no_title_type_props) do
      {
        title: [
          {
            structuredValue: [{ value: 'A title' }]
          }
        ]
      }
    end

    let(:multiple_title_structured_value_props) do
      {
        title: [
          {
            structuredValue: [{ value: 'A title', type: 'main title' }, { value: 'Another title' }]
          }
        ]
      }
    end

    let(:related_resource_no_title_type_props) do
      {
        title: [
          { value: 'A title' }
        ],
        purl: 'https://purl.stanford.edu/bc123df4567',
        relatedResource: [
          {
            title: [
              { structuredValue: [{ value: 'A related title'}] }
            ],
            type: 'related to'
          }
        ]
      }
    end

    let(:related_resource_parallel_value_no_type_props) do
      {
        title: [
          { value: 'A title' }
        ],
        purl: 'https://purl.stanford.edu/bc123df4567',
        relatedResource: [
          { title: [
            {
              parallelValue: [
                {
                  structuredValue: [
                    {
                      value: 'Les',
                      type: 'nonsorting characters'
                    },
                    {
                      value: 'misérables'
                    }
                  ]
                }
              ]
            }
          ]}
        ]
      }
    end

    let(:parallel_structured_props) do
      {
        title: [
          {
            parallelValue: [
              {
                structuredValue: [
                  {
                    value: 'Les',
                    type: 'nonsorting characters'
                  },
                  {
                    value: 'misérables'
                  }
                ]
              }
            ]
          }
        ]
      }
    end

    let(:request_desc_props) do
      desc_props.dup.tap do |props|
        props.delete(:purl)
      end
    end

    describe 'when a valid Description' do
      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    describe 'when a valid RequestDescription' do
      let(:props) { request_desc_props.with_indifferent_access }
      let(:clazz) { Cocina::Models::RequestDescription }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    describe 'when an invalid Description' do
      let(:desc_props) { invalid_desc_props }

      it 'is not valid' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError, 'Multiple value, groupedValue, structuredValue, and parallelValue in description: title1, relatedResource1.title1')
      end
    end

    describe 'when a blank value in description' do
      let(:desc_props) { blank_title_props }

      it 'is not valid' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError, 'Blank value in description: title1')
      end
    end

    describe 'when a no type for title structuredValue in description' do
      let(:desc_props) { no_title_type_props }

      it 'is not valid' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError, 'Missing type for value in description: title1.structuredValue1')
      end
    end

    describe 'when no type for second structuredValue title in description' do
      let(:desc_props) { multiple_title_structured_value_props }

      it 'is not valid' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError, 'Missing type for value in description: title1.structuredValue2')
      end
    end

    describe 'when no type for related resource structured value title in description' do
      let(:desc_props) { related_resource_no_title_type_props }

      it 'is not valid' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError, 'Missing type for value in description: relatedResource1.title1.structuredValue1')
      end
    end

    describe 'when no type for related resource parallelValue structured value title in description' do
      let(:desc_props) { related_resource_parallel_value_no_type_props }

      it 'is not valid' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError, 'Missing type for value in description: relatedResource1.title1.parallelValue1.structuredValue2')
      end
    end

    describe 'when structuredValue with no type within parallelValue' do
      let(:desc_props) { parallel_structured_props }

      it 'is not valid' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError, 'Missing type for value in description: title1.parallelValue1.structuredValue2')
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
