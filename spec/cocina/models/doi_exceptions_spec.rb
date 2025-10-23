# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::DoiExceptions do
  subject(:exception) { described_class[doi] }

  context 'with an empty string' do
    let(:doi) { '' }

    it 'fails to validate' do
      expect { exception }.to raise_error(Dry::Types::ConstraintError)
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
      expect { exception }.not_to raise_error
    end

    context 'with a mix of uppercase and lowercase letters' do
      let(:doi) { '10.25740/Auh8-V9s7' }

      it 'validates' do
        expect { exception }.not_to raise_error
      end
    end
  end

  context 'with an allowed Stanford Libraries-style DOI' do
    let(:doi) { '10.25936/629t-Bx79' }

    it 'validates' do
      expect { exception }.not_to raise_error
    end
  end

  context 'with a different Stanford Libraries-style DOI' do
    let(:doi) { '10.25936/Auh8-V9s7' }

    it 'fails to validate' do
      expect { exception }.to raise_error(Dry::Types::ConstraintError)
    end
  end
end
