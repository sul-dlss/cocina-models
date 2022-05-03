# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionValuesValidator do
  let(:validate) { described_class.validate(clazz, props) }

  let(:clazz) { Cocina::Models::Description }

  let(:props) { desc_props }

  let(:desc_props) do
    {
      title: [
        { value: 'A title' },
        { parallelValue: [{ value: 'A title' }, { value: 'Another title' }] },
        { groupedValue: [{ value: 'A title' }, { value: 'Another title' }] },
        { structuredValue: [{ value: 'A title' }, { value: 'Another title' }] },
        { valueAt: 'abc123' }
      ],
      purl: 'https://purl.stanford.edu/bc123df4567',
      relatedResource: [
        {
          title: [
            { value: 'A related title' }
          ],
          type: 'related to'
        }
      ]
    }
  end

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

  describe 'when an invalid Description' do
    let(:props) { invalid_desc_props }

    it 'is not valid' do
      expect do
        validate
      end.to raise_error(Cocina::Models::ValidationError, 'Multiple value, groupedValue, structuredValue, and parallelValue in description: title1, relatedResource1.title1')
    end
  end

  describe 'when an invalid RequestDescription' do
    let(:clazz) { Cocina::Models::RequestDRO }
    let(:props) { request_desc_props }
    let(:dro_props) { { description: invalid_desc_props } }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'when an invalid DRO' do
    let(:clazz) { Cocina::Models::DRO }
    let(:props) { dro_props }
    let(:dro_props) { { description: invalid_desc_props } }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end
end
