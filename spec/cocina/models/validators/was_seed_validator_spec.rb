# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::WasSeedValidator do
  let(:validate) { described_class.validate(Cocina::Models::DRO, props) }

  let(:props) do
    {
      externalIdentifier: 'druid:bc123df4567',
      type: Cocina::Models::ObjectType[:'webarchive-seed'],
      access: { view: 'public', download: 'none' },
      structural: { contains: [ ] },
      description:
    }
  end


  context 'when a valid webarchive' do
    let(:description) do
      {
        access: {
          url: [
            {
              displayLabel: 'Archived website',
              value: 'https://swap.stanford.edu/was/*/http://markey.house.gov/content/letters-major-data-brokers'
            }
          ]
        }
      }
    end
    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when an malformed url' do
    let(:description) do
      {
        access: {
          url: [
            {
              displayLabel: 'Archived website',
              value: 'https://swap.stanford.edu/was//http://markey.house.gov/content/letters-major-data-brokers'
            }
          ]
        }
      }
    end

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when an no url' do
    let(:description) do
      { }
    end

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end
end
