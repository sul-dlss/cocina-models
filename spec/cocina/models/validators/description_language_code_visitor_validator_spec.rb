# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionLanguageCodeVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

  let(:base_props) do
    {
      title: [{ value: 'Test Title' }],
      purl: 'https://purl.stanford.edu/bc123df4567'
    }.with_indifferent_access
  end

  describe 'when language has no code' do
    let(:props) { base_props.merge(language: [{ value: 'English' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has a valid code' do
    let(:props) { base_props.merge(language: [{ code: 'eng' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has a valid code with different case' do
    let(:props) { base_props.merge(language: [{ code: 'ENG' }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized language codes in description: language1.code (ENG)'
      )
    end
  end

  describe 'when language has code mul' do
    let(:props) { base_props.merge(language: [{ code: 'mul' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has code und' do
    let(:props) { base_props.merge(language: [{ code: 'und' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has code zxx' do
    let(:props) { base_props.merge(language: [{ code: 'zxx' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when language has an invalid code' do
    let(:props) { base_props.merge(language: [{ code: 'bogus' }]) }

    it 'raises ValidationError with path and code' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized language codes in description: language1.code (bogus)'
      )
    end
  end

  describe 'when multiple languages have invalid codes' do
    let(:props) { base_props.merge(language: [{ code: 'eng' }, { code: 'bogus' }, { code: 'fake' }]) }

    it 'raises ValidationError listing all invalid codes' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized language codes in description: language2.code (bogus), language3.code (fake)'
      )
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) { base_props.except(:purl).merge(language: [{ code: 'bogus' }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end
end
