# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionLocationVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

  let(:base_props) do
    {
      title: [{ value: 'Test Title' }],
      purl: 'https://purl.stanford.edu/bc123df4567'
    }.with_indifferent_access
  end

  describe 'when location has no source' do
    let(:props) { base_props.merge(location: [{ value: 'Stanford, California' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when location has source without code' do
    let(:props) { base_props.merge(location: [{ source: { uri: 'https://example.com' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when location has a valid source code (marccountry)' do
    let(:props) { base_props.merge(location: [{ value: 'US', source: { code: 'marccountry' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when location has a valid source code (iso3166)' do
    let(:props) { base_props.merge(location: [{ value: 'US', source: { code: 'iso3166' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when location has a valid LOC source code (tgn)' do
    let(:props) { base_props.merge(location: [{ value: 'Stanford', source: { code: 'tgn' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when location has a valid source code with different case' do
    let(:props) { base_props.merge(location: [{ value: 'US', source: { code: 'MARCCOUNTRY' } }]) }

    it 'is case-insensitive and does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when location has an invalid source code' do
    let(:props) { base_props.merge(location: [{ value: 'Test', source: { code: 'bogussource' } }]) }

    it 'raises ValidationError with path and code' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized location source codes in description: location1.source.code (bogussource)'
      )
    end
  end

  describe 'when location nested in relatedResource has an invalid source code' do
    let(:props) do
      base_props.merge(
        relatedResource: [
          {
            location: [
              { value: 'Test', source: { code: 'invalidsource' } }
            ]
          }
        ]
      )
    end

    it 'raises ValidationError with nested path' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized location source codes in description: relatedResource1.location1.source.code (invalidsource)'
      )
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) { base_props.merge(location: [{ value: 'Test', source: { code: 'invalid' } }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized location source codes in description: location1.source.code (invalid)'
      )
    end
  end

  describe 'when location has marccountry source with a valid country code' do
    let(:props) { base_props.merge(location: [{ code: 'cau', source: { code: 'marccountry' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when location has marccountry source with a valid country code (case-insensitive)' do
    let(:props) { base_props.merge(location: [{ code: 'CAU', source: { code: 'marccountry' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when location has marccountry source with no country code' do
    let(:props) { base_props.merge(location: [{ value: 'California', source: { code: 'marccountry' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when location has marccountry source with an invalid country code' do
    let(:props) { base_props.merge(location: [{ code: 'zzz', source: { code: 'marccountry' } }]) }

    it 'raises ValidationError with path and code' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Invalid MARC country codes in description: location1.code (zzz)'
      )
    end
  end

  describe 'when location has non-marccountry source with a code value' do
    let(:props) { base_props.merge(location: [{ code: 'anything', source: { code: 'iso3166' } }]) }

    it 'does not validate the code value and does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when location nested in relatedResource has marccountry source with an invalid country code' do
    let(:props) do
      base_props.merge(
        relatedResource: [
          {
            location: [
              { code: 'zz', source: { code: 'marccountry' } }
            ]
          }
        ]
      )
    end

    it 'raises ValidationError with nested path' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Invalid MARC country codes in description: relatedResource1.location1.code (zz)'
      )
    end
  end
end
