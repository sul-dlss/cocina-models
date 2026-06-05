# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::CompositeDescriptionValidator do
  describe '#validate' do
    subject(:validate) { described_class.new(clazz, attributes, validators: [validator_class]).validate }

    let(:attributes) { { title: [{ value: 'foo' }] } }
    let(:validator_instance) { instance_spy(Cocina::Models::Validators::BaseDescriptionVisitorValidator) }
    let(:validator_class) do
      spy_instance = validator_instance
      Class.new { define_singleton_method(:new) { spy_instance } }
    end

    context 'when Description' do
      let(:clazz) { Cocina::Models::Description }

      it 'calls visit_hash for each hash node' do
        validate
        expect(validator_instance).to have_received(:visit_hash).with(hash: attributes, path: [])
        expect(validator_instance).to have_received(:visit_hash).with(hash: { value: 'foo' }, path: [:title, 0])
      end

      it 'calls visit_array for each array node' do
        validate
        expect(validator_instance).to have_received(:visit_array).with(array: [{ value: 'foo' }], path: [:title])
      end

      it 'calls visit_obj for every node' do
        validate
        expect(validator_instance).to have_received(:visit_obj).with(obj: attributes, path: [])
        expect(validator_instance).to have_received(:visit_obj).with(obj: [{ value: 'foo' }], path: [:title])
        expect(validator_instance).to have_received(:visit_obj).with(obj: { value: 'foo' }, path: [:title, 0])
        expect(validator_instance).to have_received(:visit_obj).with(obj: 'foo', path: [:title, 0, :value])
      end

      it 'calls validate! once after traversal' do
        validate
        expect(validator_instance).to have_received(:validate!).once
      end
    end

    context 'when DRO' do
      let(:clazz) { Cocina::Models::DRO }

      it 'does not call any visitor methods' do
        validate
        expect(validator_instance).not_to have_received(:visit_hash)
        expect(validator_instance).not_to have_received(:visit_array)
        expect(validator_instance).not_to have_received(:visit_obj)
        expect(validator_instance).not_to have_received(:validate!)
      end
    end
  end

  describe '#meets_preconditions?' do
    let(:validator) { described_class.new(clazz, {}) }

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
