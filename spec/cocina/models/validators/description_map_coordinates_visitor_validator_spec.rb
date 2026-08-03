# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionMapCoordinatesVisitorValidator do
  let(:clazz) { Cocina::Models::Description }

  let(:props) { desc_props }

  let(:desc_props) do
    {
      title: [{ value: 'A Map' }],
      purl: 'https://purl.stanford.edu/bc123df4567',
      subject: [
        {
          type: 'map coordinates',
          value: map_coordinates_value
        }
      ],
      geographic: [
        {
          subject: [
            {
              type: 'bounding box coordinates',
              structuredValue: [
                { value: west_value, type: 'west' },
                { value: 'E1800000', type: 'east' },
                { value: 'N0840000', type: 'north' },
                { value: 'S0700000', type: 'south' }
              ]
            }
          ]
        }
      ]
    }.with_indifferent_access
  end

  let(:map_coordinates_value) { 'W 79°33ʹ--78°34ʹ/N 42°04ʹ--N 41°15ʹ' }
  let(:west_value) { 'W1800000' }

  describe '#validate' do
    let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

    describe 'with a valid map coordinates value and valid structured coordinates' do
      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    describe 'with a point coordinates type' do
      let(:desc_props) do
        {
          title: [{ value: 'A Map' }],
          purl: 'https://purl.stanford.edu/bc123df4567',
          geographic: [
            {
              subject: [
                {
                  type: 'point coordinates',
                  structuredValue: [
                    { value: '34.68444444', type: 'latitude' },
                    { value: west_value, type: 'longitude' }
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

    describe 'with an invalid map coordinates value' do
      let(:map_coordinates_value) { 'not a coordinate' }

      it 'raises' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError,
                           'Invalid map coordinates in description: subject1')
      end
    end

    describe 'with an invalid structured coordinate value' do
      let(:west_value) { 'not a coordinate' }

      it 'raises' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError,
                           'Invalid map coordinates in description: geographic1.subject1.structuredValue1')
      end
    end

    describe 'with both an invalid map coordinates value and an invalid structured coordinate value' do
      let(:map_coordinates_value) { 'not a coordinate' }
      let(:west_value) { 'not a coordinate' }

      it 'raises listing both paths' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError,
                           'Invalid map coordinates in description: subject1, geographic1.subject1.structuredValue1')
      end
    end

    describe 'with a subject value that is not map coordinates' do
      let(:desc_props) do
        {
          title: [{ value: 'A Map' }],
          purl: 'https://purl.stanford.edu/bc123df4567',
          subject: [
            {
              type: 'topic',
              value: 'not a coordinate'
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
