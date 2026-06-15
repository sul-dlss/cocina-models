# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionSubjectTemporalEncodingVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

  let(:base_props) do
    {
      title: [{ value: 'Test Title' }],
      purl: 'https://purl.stanford.edu/bc123df4567'
    }.with_indifferent_access
  end

  describe 'when subject has no encoding' do
    let(:props) { base_props.merge(subject: [{ value: '1990', type: 'time' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject type is not time' do
    let(:props) { base_props.merge(subject: [{ value: 'History', type: 'topic', encoding: { code: 'bogusenc' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has type time with a valid encoding code' do
    let(:props) { base_props.merge(subject: [{ value: '1990', type: 'time', encoding: { code: 'iso8601' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has type time with a valid encoding code (different case)' do
    let(:props) { base_props.merge(subject: [{ value: '1990', type: 'time', encoding: { code: 'ISO8601' } }]) }

    it 'is case-insensitive and does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has type time with an invalid encoding code' do
    let(:props) { base_props.merge(subject: [{ value: '1990', type: 'time', encoding: { code: 'bogusenc' } }]) }

    it 'raises ValidationError with path and code' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized subject temporal encoding codes in description: subject1.encoding.code (bogusenc)'
      )
    end
  end

  describe 'when subject has type time with edtf encoding code' do
    let(:props) { base_props.merge(subject: [{ value: '1990/2000', type: 'time', encoding: { code: 'edtf' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has type time with w3cdtf encoding code' do
    let(:props) { base_props.merge(subject: [{ value: '1990-01-01', type: 'time', encoding: { code: 'w3cdtf' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has type time with marc encoding code' do
    let(:props) { base_props.merge(subject: [{ value: '1990', type: 'time', encoding: { code: 'marc' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has type time with temper encoding code' do
    let(:props) { base_props.merge(subject: [{ value: 'Bronze Age', type: 'time', encoding: { code: 'temper' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has type time with periodo encoding code' do
    let(:props) { base_props.merge(subject: [{ value: 'Early Medieval', type: 'time', encoding: { code: 'periodo' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when structuredValue within subject has type time with an invalid encoding code' do
    let(:props) do
      base_props.merge(
        subject: [{
          structuredValue: [
            { value: '1990', type: 'time', encoding: { code: 'bogusenc' } },
            { value: '2000', type: 'time', encoding: { code: 'iso8601' } }
          ]
        }]
      )
    end

    it 'raises ValidationError with nested path' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized subject temporal encoding codes in description: subject1.structuredValue1.encoding.code (bogusenc)'
      )
    end
  end

  describe 'when structuredValue within subject has type time with valid encoding codes' do
    let(:props) do
      base_props.merge(
        subject: [{
          structuredValue: [
            { value: '1990', type: 'time', encoding: { code: 'iso8601' } },
            { value: '2000', type: 'time', encoding: { code: 'edtf' } }
          ]
        }]
      )
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) { base_props.except(:purl).merge(subject: [{ value: '1990', type: 'time', encoding: { code: 'bogusenc' } }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end
end
