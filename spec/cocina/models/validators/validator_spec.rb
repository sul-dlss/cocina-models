# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::Validator do
  subject(:validate) { described_class.validate(clazz, props) }

  let(:clazz) { Cocina::Models::DRO }

  let(:props) do
    # Deliberately not using factory to control validation.
    {
      type: Cocina::Models::ObjectType.object,
      version: 1,
      label: 'DRO label',
      access: {},
      administrative: {hasAdminPolicy: 'druid:hv992ry2431'},
      description: {title: [{value: 'DRO title'}], purl: 'https://purl.stanford.edu/bc234fg5678'},
      identification: {sourceId: 'sul:1234'},
      structural: {isMemberOf: []},
      externalIdentifier: 'druid:bc234fg5678'
    }.deep_stringify_keys
  end

  context 'with a props hash' do
    before do
      Cocina::Models::Validators::Validator::VALIDATORS.each do |validator_clazz|
        allow(validator_clazz).to receive(:validate)
      end
    end

    it 'invokes validators' do
      validate

      expect(Cocina::Models::Validators::Validator::VALIDATORS).to all(have_received(:validate).with(Cocina::Models::DRO,
                                                                                                     props))
    end
  end

  # Yes, this can happen.
  context 'with a mixed hash' do
    {
      type: Cocina::Models::ObjectType.object,
      version: 1,
      label: 'DRO label',
      access: {},
      administrative: {hasAdminPolicy: 'druid:hv992ry2431'},
      description: {title: [Cocina::Models::Title.new(value: 'DRO title')], purl: 'https://purl.stanford.edu/bc234fg5678'},
      identification: {sourceId: 'sul:1234'},
      structural: {isMemberOf: []},
      externalIdentifier: 'druid:bc234fg5678'
    }.deep_stringify_keys

    before do
      Cocina::Models::Validators::Validator::VALIDATORS.each do |validator_clazz|
        allow(validator_clazz).to receive(:validate)
      end
    end

    it 'invokes validators' do
      validate

      expect(Cocina::Models::Validators::Validator::VALIDATORS).to all(have_received(:validate).with(Cocina::Models::DRO,
                                                                                                     props))
    end
  end

  context 'with a valid hash' do
    it 'does not raise an error' do
      expect { validate }.not_to raise_error
    end
  end
end
