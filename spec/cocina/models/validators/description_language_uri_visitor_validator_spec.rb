# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionLanguageUriVisitorValidator do
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

  describe 'when language has no uri' do
    let(:props) { base_props.merge(language: [{ value: 'English', code: 'eng' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has a valid http URI' do
    let(:props) { base_props.merge(language: [{ value: 'English', uri: 'http://id.loc.gov/vocabulary/iso639-2/eng' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has a valid https URI' do
    let(:props) { base_props.merge(language: [{ value: 'English', uri: 'https://id.loc.gov/vocabulary/iso639-2/eng' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has an invalid URI' do
    let(:props) { base_props.merge(language: [{ uri: 'http://id.loc.gov/vocabulary/iso639-2/bogus' }]) }

    it 'raises ValidationError with path and URI' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Invalid language URIs in description: language1.uri (http://id.loc.gov/vocabulary/iso639-2/bogus)'
      )
    end
  end

  describe 'when language has a valid languages vocabulary URI' do
    let(:props) { base_props.merge(language: [{ value: 'English', uri: 'http://id.loc.gov/vocabulary/languages/eng' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has an invalid languages vocabulary URI' do
    let(:props) { base_props.merge(language: [{ uri: 'http://id.loc.gov/vocabulary/languages/bogus' }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'when language has an approved iso639-3 URI' do
    %w[ase dnt quc skr trw].each do |code|
      describe "for code #{code}" do
        let(:props) { base_props.merge(language: [{ uri: "http://id.loc.gov/vocabulary/iso639-3/#{code}" }]) }

        it 'does not raise' do
          expect { validate }.not_to raise_error
        end
      end
    end
  end

  describe 'when language has an unapproved iso639-3 URI' do
    let(:props) { base_props.merge(language: [{ uri: 'http://id.loc.gov/vocabulary/iso639-3/eng' }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'when valueLanguage has a valid URI' do
    let(:props) do
      base_props.merge(
        language: [{ value: 'English', valueLanguage: { uri: 'http://id.loc.gov/vocabulary/iso639-2/eng' } }]
      )
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when valueLanguage has an invalid URI' do
    let(:props) do
      base_props.merge(
        language: [{ value: 'English', valueLanguage: { uri: 'http://id.loc.gov/vocabulary/iso639-2/bogus' } }]
      )
    end

    it 'raises ValidationError with path and URI' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Invalid language URIs in description: language1.valueLanguage.uri (http://id.loc.gov/vocabulary/iso639-2/bogus)'
      )
    end
  end

  describe 'when valueLanguage has no uri' do
    let(:props) do
      base_props.merge(
        language: [{ value: 'English', valueLanguage: { value: 'English' } }]
      )
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) { base_props.except(:purl).merge(language: [{ uri: 'http://id.loc.gov/vocabulary/iso639-2/bogus' }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'when multiple languages have invalid URIs' do
    let(:props) do
      base_props.merge(
        language: [
          { uri: 'http://id.loc.gov/vocabulary/iso639-2/bad1' },
          { uri: 'http://id.loc.gov/vocabulary/iso639-2/bad2' }
        ]
      )
    end

    it 'raises ValidationError listing all invalid paths' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        /language1\.uri.*language2\.uri/
      )
    end
  end
end
