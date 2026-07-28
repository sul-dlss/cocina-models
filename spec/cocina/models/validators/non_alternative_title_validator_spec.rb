# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::NonAlternativeTitleValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:attributes) { { title: [{ value: 'Gaudy night' }] } }

  describe '#validate' do
    let(:validate) { described_class.validate(clazz, attributes) }

    context 'when no description' do
      let(:attributes) { {} }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when title has no type' do
      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when title has a non-alternative type' do
      let(:attributes) do
        { title: [{ value: 'Gaudy night', type: 'main title' }] }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when one of multiple titles is non-alternative' do
      let(:attributes) do
        {
          title: [
            { value: 'Five red herrings' },
            { value: 'Suspicious characters', type: 'alternative' }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when the only title is alternative' do
      let(:attributes) do
        { title: [{ value: 'Suspicious characters', type: 'alternative' }] }
      end

      it 'raises' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError,
                           "At least one title must have no type or a type other than 'alternative'.")
      end
    end

    context 'when relatedResource has only an alternative title' do
      let(:attributes) do
        {
          title: [{ value: 'Gaudy night' }],
          relatedResource: [
            { title: [{ value: 'Suspicious characters', type: 'alternative' }] }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when relatedResource has no title' do
      let(:attributes) do
        {
          title: [{ value: 'Gaudy night' }],
          relatedResource: [
            { contributor: [{ name: [{ value: 'Sayers, Dorothy L.' }] }] }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when relatedResource has a valid title' do
      let(:attributes) do
        {
          title: [{ value: 'Gaudy night' }],
          relatedResource: [
            { title: [{ value: 'Gaudy night', type: 'supplied' }] }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end
  end

  describe '#meets_preconditions?' do
    subject(:meets_preconditions) { validator.send(:meets_preconditions?) }

    let(:validator) { described_class.new(clazz, attributes) }

    context 'when RequestDescription' do
      let(:clazz) { Cocina::Models::RequestDescription }

      it { is_expected.to be true }
    end

    context 'when Description' do
      let(:clazz) { Cocina::Models::Description }

      it { is_expected.to be true }
    end

    context 'when DRO' do
      let(:clazz) { Cocina::Models::DRO }

      it { is_expected.to be false }
    end
  end
end
