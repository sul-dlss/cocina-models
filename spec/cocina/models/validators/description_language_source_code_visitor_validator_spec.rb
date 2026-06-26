# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionLanguageSourceCodeVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

  let(:base_props) do
    {
      title: [{ value: 'Test Title' }],
      purl: 'https://purl.stanford.edu/bc123df4567'
    }.with_indifferent_access
  end

  describe 'when there is no language' do
    let(:props) { base_props }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has no source' do
    let(:props) { base_props.merge(language: [{ value: 'English', code: 'eng' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has source without code' do
    let(:props) { base_props.merge(language: [{ source: { uri: 'https://example.com' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has a valid source code' do
    let(:props) { base_props.merge(language: [{ value: 'English', code: 'eng', source: { code: 'iso639-3' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has a valid source code with different case' do
    let(:props) { base_props.merge(language: [{ value: 'English', source: { code: 'ISO639-2B' } }]) }

    it 'is case-insensitive and does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has an invalid source code' do
    let(:props) { base_props.merge(language: [{ value: 'English', source: { code: 'bogussource' } }]) }

    it 'raises ValidationError with path and code' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized language source codes in description: language1.source.code (bogussource)'
      )
    end
  end

  describe 'when multiple language entries have invalid source codes' do
    let(:props) do
      base_props.merge(
        language: [
          { value: 'English', source: { code: 'badsource1' } },
          { value: 'French', source: { code: 'badsource2' } }
        ]
      )
    end

    it 'raises ValidationError listing all invalid paths' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        /language1\.source\.code.*language2\.source\.code/
      )
    end
  end

  describe 'when valueLanguage has no source' do
    let(:props) do
      base_props.merge(
        language: [{ value: 'English', valueLanguage: { value: 'English' } }]
      )
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when valueLanguage has source without code' do
    let(:props) do
      base_props.merge(
        language: [{ value: 'English', valueLanguage: { source: { uri: 'https://example.com' } } }]
      )
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when valueLanguage has a valid source code' do
    let(:props) do
      base_props.merge(
        language: [{ value: 'English', valueLanguage: { source: { code: 'iso639-3' } } }]
      )
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when valueLanguage has an invalid source code' do
    let(:props) do
      base_props.merge(
        language: [{ value: 'English', valueLanguage: { source: { code: 'bogussource' } } }]
      )
    end

    it 'raises ValidationError with path and code' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized language source codes in description: language1.valueLanguage.source.code (bogussource)'
      )
    end
  end

  describe 'when language is nested in relatedResource and has an invalid source code' do
    let(:props) do
      base_props.merge(
        relatedResource: [
          {
            language: [
              { value: 'English', source: { code: 'invalidsource' } }
            ]
          }
        ]
      )
    end

    it 'raises ValidationError with nested path' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized language source codes in description: relatedResource1.language1.source.code (invalidsource)'
      )
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) { base_props.except(:purl).merge(language: [{ value: 'English', source: { code: 'invalidsource' } }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized language source codes in description: language1.source.code (invalidsource)'
      )
    end
  end
end
