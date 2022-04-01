# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validatable do
  let(:props) do
    {
      externalIdentifier: 'druid:bc123df4567',
      label: 'My admin policy',
      type: Cocina::Models::ObjectType.admin_policy,
      version: 1,
      administrative: administrative_props
    }
  end

  let(:administrative_props) do
    {
      hasAdminPolicy: 'druid:bc123df4567',
      hasAgreement: 'druid:bc123df4567',
      accessTemplate: {}
    }
  end

  before do
    allow(Cocina::Models::Validators::Validator).to receive(:validate)
  end

  context 'when validating a Validatable' do
    it 'performs validation' do
      Cocina::Models::AdminPolicy.new(props)
      expect(Cocina::Models::Validators::Validator).to have_received(:validate)
    end
  end

  context 'when not validating a Validatable' do
    it 'does not perform validation' do
      Cocina::Models::AdminPolicy.new(props, false, false)
      expect(Cocina::Models::Validators::Validator).not_to have_received(:validate)
    end
  end

  context 'when validating a Validatable created from existing object' do
    it 'performs validation' do
      Cocina::Models::AdminPolicy.new(props).new(label: 'My new admin policy')
      expect(Cocina::Models::Validators::Validator).to have_received(:validate).twice
    end
  end

  context 'when not validating a Validatable created from existing object' do
    it 'does not perform validation' do
      Cocina::Models::AdminPolicy.new(props).new(label: 'My new admin policy', validate: false)
      expect(Cocina::Models::Validators::Validator).to have_received(:validate).once
    end
  end

  context 'when not a Validatable' do
    it 'does not perform validation' do
      Cocina::Models::AdminPolicyAdministrative.new(administrative_props)
      expect(Cocina::Models::Validators::Validator).not_to have_received(:validate)
    end
  end
end
