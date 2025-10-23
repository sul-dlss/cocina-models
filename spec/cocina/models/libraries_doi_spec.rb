# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::LibrariesDOI do
  subject(:exception) { described_class[doi] }

  context 'with a Stanford Libraries DOI' do
    let(:doi) { '10.25936/629t-Bx79' }

    it 'validates' do
      expect { exception }.not_to raise_error
    end
  end

  context 'with an SDR-style DOI' do
    let(:doi) { '10.25740/bc123df4567' }

    it 'fails to validate' do
      expect { exception }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  context 'with a pre-registered style DOI' do
    let(:doi) { '10.25740/auh8-v9s7' }

    it 'validates' do
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
