# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionIdentifierSourceCodeVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

  let(:base_props) do
    {
      title: [{ value: 'Test Title' }],
      purl: 'https://purl.stanford.edu/bc123df4567'
    }.with_indifferent_access
  end

  describe 'when identifier has no source' do
    let(:props) { base_props.merge(identifier: [{ value: '12345', type: 'local' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when identifier has source without code' do
    let(:props) { base_props.merge(identifier: [{ value: '12345', source: { uri: 'https://example.com' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when identifier has a valid source code' do
    let(:props) { base_props.merge(identifier: [{ value: '10.1000/xyz123', source: { code: 'doi' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when identifier has a valid source code with different case' do
    let(:props) { base_props.merge(identifier: [{ value: '10.1000/xyz123', source: { code: 'DOI' } }]) }

    it 'is case-insensitive and does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when identifier has an invalid source code' do
    let(:props) { base_props.merge(identifier: [{ value: '12345', source: { code: 'bogusregistry' } }]) }

    it 'raises ValidationError with path and code' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized identifier source codes in description: identifier1.source.code (bogusregistry)'
      )
    end
  end

  describe 'when identifier nested in contributor has a valid source code' do
    let(:props) do
      base_props.merge(
        contributor: [{
          type: 'person',
          name: [{ value: 'Smith, Jane' }],
          identifier: [{ value: '0000-0000-0000-0000', source: { code: 'orcid' } }]
        }]
      )
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when identifier nested in contributor has an invalid source code' do
    let(:props) do
      base_props.merge(
        contributor: [{
          type: 'person',
          name: [{ value: 'Smith, Jane' }],
          identifier: [{ value: '12345', source: { code: 'bogusregistry' } }]
        }]
      )
    end

    it 'raises ValidationError with nested path' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized identifier source codes in description: contributor1.identifier1.source.code (bogusregistry)'
      )
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) { base_props.except(:purl).merge(identifier: [{ value: '12345', source: { code: 'bogusregistry' } }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'when identifier has swets source code' do
    let(:props) { base_props.merge(identifier: [{ value: '12345', source: { code: 'swets' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when identifier has apis source code' do
    let(:props) { base_props.merge(identifier: [{ value: '12345', source: { code: 'apis' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end
end
