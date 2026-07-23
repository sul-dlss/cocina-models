# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::NonAlternativeTitleValidator do
  let(:clazz) { Cocina::Models::Description }

  let(:props) { {} }

  describe '#validate' do
    let(:validate) { described_class.validate(clazz, props) }

    context 'when no description' do
      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when title has no type' do
      let(:props) do
        { title: [{ value: 'Gaudy night' }] }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when title has a non-alternative type' do
      let(:props) do
        { title: [{ value: 'Gaudy night', type: 'main title' }] }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when one of multiple titles is non-alternative' do
      let(:props) do
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
      let(:props) do
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
      let(:props) do
        {
          title: [{ value: 'Gaudy night' }],
          relatedResource: [
            { title: [{ value: 'Suspicious characters', type: 'alternative' }] }
          ]
        }
      end

      it 'raises' do
        expect do
          validate
        end.to raise_error(Cocina::Models::ValidationError,
                           "At least one title must have no type or a type other than 'alternative'.")
      end
    end

    context 'when relatedResource has no title' do
      let(:props) do
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
      let(:props) do
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
    let(:validator) { described_class.new(clazz, props) }

    let(:meets_preconditions) { validator.send(:meets_preconditions?) }

    context 'when RequestDescription' do
      let(:clazz) { Cocina::Models::RequestDescription }

      it 'meets preconditions' do
        expect(meets_preconditions).to be true
      end
    end

    context 'when Description' do
      let(:clazz) { Cocina::Models::Description }

      it 'meets preconditions' do
        expect(meets_preconditions).to be true
      end
    end

    context 'when DRO' do
      let(:clazz) { Cocina::Models::DRO }

      it 'does not meet preconditions' do
        expect(meets_preconditions).to be false
      end
    end
  end
end
