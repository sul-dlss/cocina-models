# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionFormResourceTypeVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

  let(:base_props) do
    {
      title: [{ value: 'Test Title' }],
      purl: 'https://purl.stanford.edu/bc123df4567'
    }.with_indifferent_access
  end

  describe 'when form has no type' do
    let(:props) { base_props.merge(form: [{ value: 'text', source: { value: 'MODS resource type' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when form type is not resource type' do
    let(:props) { base_props.merge(form: [{ value: 'book', type: 'genre', source: { value: 'MODS resource type' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when form has no source' do
    let(:props) { base_props.merge(form: [{ value: 'bogus', type: 'resource type' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when form source value is unknown' do
    let(:props) { base_props.merge(form: [{ value: 'bogus', type: 'resource type', source: { value: 'DataCite' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when form has no value' do
    let(:props) { base_props.merge(form: [{ type: 'resource type', source: { value: 'MODS resource type' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'MODS resource type' do
    describe 'when value is valid' do
      let(:props) { base_props.merge(form: [{ value: 'text', type: 'resource type', source: { value: 'MODS resource type' } }]) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    describe 'when value is valid (sound recording-musical)' do
      let(:props) { base_props.merge(form: [{ value: 'sound recording-musical', type: 'resource type', source: { value: 'MODS resource type' } }]) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    describe 'when value is invalid' do
      let(:props) { base_props.merge(form: [{ value: 'bogus value', type: 'resource type', source: { value: 'MODS resource type' } }]) }

      it 'raises ValidationError with path and value' do
        expect { validate }.to raise_error(
          Cocina::Models::ValidationError,
          'Unrecognized resource type values in description: form1 (bogus value)'
        )
      end
    end

    describe 'when value uses wrong case' do
      let(:props) { base_props.merge(form: [{ value: 'Text', type: 'resource type', source: { value: 'MODS resource type' } }]) }

      it 'raises ValidationError' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError)
      end
    end
  end

  describe 'LC Resource Type Scheme' do
    describe 'when value is valid' do
      let(:props) { base_props.merge(form: [{ value: 'Still image', type: 'resource type', source: { value: 'LC Resource Type Scheme' } }]) }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    describe 'when value is invalid' do
      let(:props) { base_props.merge(form: [{ value: 'bogus value', type: 'resource type', source: { value: 'LC Resource Type Scheme' } }]) }

      it 'raises ValidationError with path and value' do
        expect { validate }.to raise_error(
          Cocina::Models::ValidationError,
          'Unrecognized resource type values in description: form1 (bogus value)'
        )
      end
    end

    describe 'when value uses wrong case' do
      let(:props) { base_props.merge(form: [{ value: 'still image', type: 'resource type', source: { value: 'LC Resource Type Scheme' } }]) }

      it 'raises ValidationError' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError)
      end
    end
  end

  describe 'when multiple form entries have invalid values' do
    let(:props) do
      base_props.merge(
        form: [
          { value: 'bad1', type: 'resource type', source: { value: 'MODS resource type' } },
          { value: 'bad2', type: 'resource type', source: { value: 'LC Resource Type Scheme' } }
        ]
      )
    end

    it 'raises ValidationError listing all invalid paths' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized resource type values in description: form1 (bad1), form2 (bad2)'
      )
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) { base_props.except(:purl).merge(form: [{ value: 'bogus', type: 'resource type', source: { value: 'MODS resource type' } }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end
end
