# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionEventDateVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:props) { desc_props.with_indifferent_access }

  describe '#validate' do
    let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

    describe 'when event date structuredValue has type without value' do
      let(:desc_props) do
        {
          title: [{ value: 'A title' }],
          purl: 'https://purl.stanford.edu/bc123df4567',
          event: [
            {
              date: [
                {
                  structuredValue: [
                    { value: '1920', type: 'start' },
                    { type: 'end' }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'is not valid' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError, 'Missing value for type in description: event1.date1.structuredValue2')
      end
    end

    describe 'when event date structuredValue within parallelValue has type without value' do
      let(:desc_props) do
        {
          title: [{ value: 'A title' }],
          purl: 'https://purl.stanford.edu/bc123df4567',
          event: [
            {
              date: [
                {
                  parallelValue: [
                    {
                      structuredValue: [
                        { value: '1920', type: 'start' },
                        { type: 'end' }
                      ]
                    }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'is not valid' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError, 'Missing value for type in description: event1.date1.parallelValue1.structuredValue2')
      end
    end

    describe 'when event date structuredValue has both type and value' do
      let(:desc_props) do
        {
          title: [{ value: 'A title' }],
          purl: 'https://purl.stanford.edu/bc123df4567',
          event: [
            {
              date: [
                {
                  structuredValue: [
                    { value: '1920', type: 'start' },
                    { value: '1925', type: 'end' }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end
  end
end
