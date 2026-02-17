# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validatable do
  let(:props) do
    # Deliberately not using factory to control validation.
    {
      type: Cocina::Models::ObjectType.object,
      version: 1,
      label: 'DRO label',
      externalIdentifier: 'druid:bc123df4567',
      access: {},
      administrative: administrative_props,
      description: description_props,
      identification: {sourceId: 'sul:1234'},
      structural: {isMemberOf: []}
    }
  end

  let(:description_props) do
    {title: [{value: 'DRO title'}], purl: 'https://purl.stanford.edu/bc123df4567'}
  end

  let(:administrative_props) do
    {
      hasAdminPolicy: 'druid:bc123df4567'
    }
  end

  before do
    allow(Cocina::Models::Validators::Validator).to receive(:validate).and_call_original
  end

  context 'when validating a Validatable' do
    it 'performs validation' do
      Cocina::Models::DRO.new(props)
      expect(Cocina::Models::Validators::Validator).to have_received(:validate).with(Cocina::Models::DRO, props)
      expect(Cocina::Models::Validators::Validator).to have_received(:validate).with(Cocina::Models::Description, description_props)
    end

    context 'when top-level object is invalid' do
      # That is, this is a validation perform on the DRO.
      let(:description_props) do
        {title: [{value: 'DRO title'}], purl: 'https://purl.stanford.edu/xc123df4567'}
      end

      it 'raises ValidationError' do
        expect { Cocina::Models::DRO.new(props) }.to raise_error(Cocina::Models::ValidationError, /Purl mismatch/)
      end
    end

    context 'when nested object is invalid' do
      # This is validated on the Description.
      let(:description_props) do
        {title: [{structuredValue: [{value: 'DRO title', type: 'partname'}]}], purl: 'https://purl.stanford.edu/bc123df4567'}
      end

      it 'raises ValidationError' do
        skip('DescriptionTypesValidator has been temporarily disabled')
        expect { Cocina::Models::DRO.new(props) }.to raise_error(Cocina::Models::ValidationError, /Unrecognized types in description/)
      end
    end
  end

  context 'when not validating a Validatable' do
    it 'does not perform validation' do
      Cocina::Models::DRO.new(props, false, false)
      expect(Cocina::Models::Validators::Validator).not_to have_received(:validate).with(Cocina::Models::DRO, props)
      # This is a flaw. Nested Validatables are still validated.
      expect(Cocina::Models::Validators::Validator).to have_received(:validate).with(Cocina::Models::Description, description_props)
    end
  end

  context 'when validating a Validatable created from existing object' do
    it 'performs validation' do
      Cocina::Models::DRO.new(props).new(label: 'My new DRO')
      expect(Cocina::Models::Validators::Validator).to have_received(:validate).with(Cocina::Models::DRO, props)
      expect(Cocina::Models::Validators::Validator).to have_received(:validate).with(Cocina::Models::Description, description_props)
    end
  end

  context 'when not validating a Validatable created from existing object' do
    it 'does not perform validation' do
      Cocina::Models::DRO.new(props).new(label: 'My new DRO', validate: false)
      expect(Cocina::Models::Validators::Validator).to have_received(:validate).with(Cocina::Models::DRO, props)
      expect(Cocina::Models::Validators::Validator).to have_received(:validate).with(Cocina::Models::Description, description_props)
    end
  end

  context 'when not a Validatable' do
    it 'does not perform validation' do
      Cocina::Models::Administrative.new(administrative_props)
      expect(Cocina::Models::Validators::Validator).not_to have_received(:validate)
    end
  end
end
