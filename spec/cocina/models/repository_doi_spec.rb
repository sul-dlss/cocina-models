# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::RepositoryDOI do
  subject(:exception) { described_class[doi] }

  context 'with a SDR-style DOI using the production prefix' do
    let(:doi) { '10.25740/bc123df4567' }

    it 'validates' do
      expect { exception }.not_to raise_error
    end
  end

  context 'with a SDR-style DOI using the test prefix' do
    let(:doi) { '10.80343/bc123df4567' }

    it 'validates' do
      expect { exception }.not_to raise_error
    end
  end

  context 'with a SDR-style DOI using mixed case' do
    let(:doi) { '10.25740/Bc123dF4567' }

    it 'fails to validate' do
      expect { exception }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  context 'with a pre-registered style DOI' do
    let(:doi) { '10.25740/auh8-v9s7' }

    it 'fails to validate' do
      expect { exception }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  context 'with a Stanford Libraries-style DOI' do
    let(:doi) { '10.25936/629t-Bx79' }

    it 'fails to validate' do
      expect { exception }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  context 'with an empty string' do
    let(:doi) { '' }

    it 'fails to validate' do
      expect { exception }.to raise_error(Dry::Types::ConstraintError)
    end
  end
end
