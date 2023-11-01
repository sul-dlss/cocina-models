# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionValuesValidator do
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
      let(:props) { request_desc_props }
      let(:clazz) { Cocina::Models::RequestDescription }

      it 'does not raise' do
        expect { validate }.not_to raise_error
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

    describe 'when a blank value in description' do
      let(:props) { blank_title_props }

      it 'is not valid' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError, 'Blank value in description: title1')
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
