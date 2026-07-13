# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionFormSourceCodeVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

  let(:base_props) do
    {
      title: [{ value: 'Test Title' }],
      purl: 'https://purl.stanford.edu/bc123df4567'
    }.with_indifferent_access
  end

  describe 'when form has no source' do
    let(:props) { base_props.merge(form: [{ value: 'Photographs' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when form has source without code' do
    let(:props) { base_props.merge(form: [{ value: 'Photographs', source: { value: 'LC Genre/Form Terms' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when form has a valid source code' do
    let(:props) { base_props.merge(form: [{ value: 'Photographs', source: { code: 'lcgft' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when form has a valid source code with different case' do
    let(:props) { base_props.merge(form: [{ value: 'Photographs', source: { code: 'LCGFT' } }]) }

    it 'is case-insensitive and does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when form has an invalid source code' do
    let(:props) { base_props.merge(form: [{ value: 'Photographs', source: { code: 'bogusregistry' } }]) }

    it 'raises ValidationError with path and code' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized form source codes in description: form1.source.code (bogusregistry)'
      )
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) { base_props.except(:purl).merge(form: [{ value: 'Photographs', source: { code: 'bogusregistry' } }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'when form has a valid source code from the subject list' do
    let(:props) { base_props.merge(form: [{ value: 'History', source: { code: 'lcsh' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end
end
