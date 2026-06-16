# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionRoleSourceCodeVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

  let(:base_props) do
    {
      title: [{ value: 'Test Title' }],
      purl: 'https://purl.stanford.edu/bc123df4567'
    }.with_indifferent_access
  end

  describe 'when contributor role has no source' do
    let(:props) do
      base_props.merge(
        contributor: [{
          type: 'person',
          name: [{ value: 'Doe, Jane' }],
          role: [{ value: 'author', code: 'aut' }]
        }]
      )
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when contributor role has source without code' do
    let(:props) do
      base_props.merge(
        contributor: [{
          type: 'person',
          name: [{ value: 'Doe, Jane' }],
          role: [{ value: 'author', source: { uri: 'http://example.com' } }]
        }]
      )
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when contributor role has a valid source code' do
    let(:props) do
      base_props.merge(
        contributor: [{
          type: 'person',
          name: [{ value: 'Doe, Jane' }],
          role: [{ value: 'author', source: { code: 'marcrelator' } }]
        }]
      )
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when contributor role has a valid source code with different case' do
    let(:props) do
      base_props.merge(
        contributor: [{
          type: 'person',
          name: [{ value: 'Doe, Jane' }],
          role: [{ value: 'author', source: { code: 'MARCRELATOR' } }]
        }]
      )
    end

    it 'is case-insensitive and does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when contributor role has an invalid source code' do
    let(:props) do
      base_props.merge(
        contributor: [{
          type: 'person',
          name: [{ value: 'Doe, Jane' }],
          role: [{ value: 'author', source: { code: 'bogussource' } }]
        }]
      )
    end

    it 'raises ValidationError with path and code' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized role source codes in description: contributor1.role1.source.code (bogussource)'
      )
    end
  end

  describe 'when relatedResource contributor role has an invalid source code' do
    let(:props) do
      base_props.merge(
        relatedResource: [{
          type: 'related to',
          title: [{ value: 'Related title' }],
          contributor: [{
            type: 'person',
            name: [{ value: 'Doe, Jane' }],
            role: [{ value: 'author', source: { code: 'bogussource' } }]
          }]
        }]
      )
    end

    it 'raises ValidationError with nested path' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized role source codes in description: relatedResource1.contributor1.role1.source.code (bogussource)'
      )
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) do
      base_props.except(:purl).merge(
        contributor: [{
          type: 'person',
          name: [{ value: 'Doe, Jane' }],
          role: [{ value: 'author', source: { code: 'bogussource' } }]
        }]
      )
    end

    it 'raises ValidationError' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end
end
