# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionTitleSourceCodeVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

  let(:base_props) do
    {
      title: [{ value: 'Test Title' }],
      purl: 'https://purl.stanford.edu/bc123df4567'
    }.with_indifferent_access
  end

  describe 'when title has no source' do
    let(:props) { base_props.merge(title: [{ value: 'A Title' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when title has source without code' do
    let(:props) { base_props.merge(title: [{ value: 'A Title', source: { uri: 'https://example.com' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when title has a valid source code (naf)' do
    let(:props) { base_props.merge(title: [{ value: 'Smith, John', source: { code: 'naf' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when title has a valid source code (viaf)' do
    let(:props) { base_props.merge(title: [{ value: 'Smith, John', source: { code: 'viaf' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when title has a valid source code with different case' do
    let(:props) { base_props.merge(title: [{ value: 'Smith, John', source: { code: 'NAF' } }]) }

    it 'is case-insensitive and does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when title has an invalid source code' do
    let(:props) { base_props.merge(title: [{ value: 'Test', source: { code: 'bogussource' } }]) }

    it 'raises ValidationError with path and code' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized title source codes in description: title1.source.code (bogussource)'
      )
    end
  end

  describe 'when title nested in relatedResource has an invalid source code' do
    let(:props) do
      base_props.merge(
        relatedResource: [
          {
            title: [
              { value: 'Test', source: { code: 'invalidsource' } }
            ]
          }
        ]
      )
    end

    it 'raises ValidationError with nested path' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized title source codes in description: relatedResource1.title1.source.code (invalidsource)'
      )
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) { base_props.merge(title: [{ value: 'Test', source: { code: 'invalid' } }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized title source codes in description: title1.source.code (invalid)'
      )
    end
  end
end
