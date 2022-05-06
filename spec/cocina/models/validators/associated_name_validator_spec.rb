# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::AssociatedNameValidator do
  let(:validate) { described_class.validate(clazz, props) }

  let(:clazz) { Cocina::Models::Description }

  let(:desc_props) do
    {
      title: [
        {
          value: 'A title',
          type: 'uniform',
          note: [
            {
              value: 'Smith, John',
              type: 'associated name'
            }
          ]
        }
      ],
      contributor: [
        {
          name: [
            {
              value: contributor_name
            }
          ]
        }
      ]
    }
  end

  let(:props) { desc_props }

  let(:contributor_name) { 'Smith, John' }

  context 'when no description' do
    let(:props) { {} }

    it 'does not raise' do
      validate
    end
  end

  context 'when no associated name' do
    let(:props) do
      {
        title: [
          {
            value: 'A title',
            type: 'uniform',
            note: [
              {
                value: 'Smith, John',
                type: 'not an associated name'
              }
            ]
          }
        ],
        relatedResource: [
          {
            title: [
              {
                value: 'A title',
                type: 'uniform'
              }
            ]
          }
        ]
      }
    end

    it 'does not raise' do
      validate
    end
  end

  context 'when valid Description with name title group' do
    it 'does not raise' do
      validate
    end
  end

  context 'when invalid Description with name title group' do
    let(:contributor_name) { 'not Smith, John' }

    it 'raises' do
      expect do
        validate
      end.to raise_error(Cocina::Models::ValidationError,
                         'Missing data: Name associated with uniform title does not match any contributor.')
    end
  end

  context 'when invalid Description with missing contributors' do
    let(:props) do
      props = desc_props.dup
      props.delete(:contributor)
      props
    end

    it 'raises' do
      expect do
        validate
      end.to raise_error(Cocina::Models::ValidationError,
                         'Missing data: Name associated with uniform title does not match any contributor.')
    end
  end

  context 'when valid Description with related resource' do
    let(:props) { { relatedResource: [desc_props] } }

    it 'does not raise' do
      validate
    end
  end

  context 'when invalid Description with related resource' do
    let(:props) { { relatedResource: [desc_props] } }

    let(:contributor_name) { 'not Smith, John' }

    it 'raises' do
      expect do
        validate
      end.to raise_error(Cocina::Models::ValidationError,
                         'Missing data: Name associated with uniform title does not match any contributor.')
    end
  end

  context 'when valid RequestDescription with name title group' do
    let(:clazz) { Cocina::Models::RequestDescription }

    it 'does not raise' do
      validate
    end
  end

  context 'when invalid RequestDescription with name title group' do
    let(:clazz) { Cocina::Models::RequestDescription }

    let(:contributor_name) { 'not Smith, John' }

    it 'raises' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when invalid DRO with name title group' do
    let(:clazz) { Cocina::Models::DRO }

    let(:contributor_name) { 'not Smith, John' }

    let(:props) { { description: desc_props } }

    it 'does not validate' do
      expect { validate }.not_to raise_error(Cocina::Models::ValidationError)
    end
  end
end
