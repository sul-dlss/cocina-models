# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::CompositeStructuralValidator do
  describe '#validate' do
    subject(:validate) { described_class.new(clazz, attributes, validators: [validator_class]).validate }

    let(:file1) do # rubocop:disable RSpec/IndexedLet
      { filename: 'file1.txt', access: { view: 'dark' }, administrative: { shelve: false }, hasMessageDigests: [] }
    end

    let(:file2) do # rubocop:disable RSpec/IndexedLet
      { filename: 'file2.txt', access: { view: 'dark' }, administrative: { shelve: false }, hasMessageDigests: [] }
    end

    let(:attributes) do
      {
        access: { view: 'dark' },
        structural: {
          contains: [
            {
              structural: {
                contains: [file1, file2]
              }
            }
          ]
        }
      }
    end

    let(:validator_instance) { instance_spy(Cocina::Models::Validators::BaseStructuralVisitorValidator) }
    let(:validator_class) do
      spy_instance = validator_instance
      Class.new { define_singleton_method(:new) { |_attrs| spy_instance } }
    end

    context 'when DRO' do
      let(:clazz) { Cocina::Models::DRO }

      it 'calls visit_file for each file' do
        validate
        expect(validator_instance).to have_received(:visit_file).with(file_hash: file1)
        expect(validator_instance).to have_received(:visit_file).with(file_hash: file2)
      end

      it 'calls validate! once after traversal' do
        validate
        expect(validator_instance).to have_received(:validate!).once
      end
    end

    context 'when RequestDRO' do
      let(:clazz) { Cocina::Models::RequestDRO }

      it 'calls visit_file for each file' do
        validate
        expect(validator_instance).to have_received(:visit_file).with(file_hash: file1)
        expect(validator_instance).to have_received(:visit_file).with(file_hash: file2)
      end
    end

    context 'when not a DRO' do
      let(:clazz) { Cocina::Models::Collection }

      it 'does not call any visitor methods' do
        validate
        expect(validator_instance).not_to have_received(:visit_file)
        expect(validator_instance).not_to have_received(:validate!)
      end
    end

    context 'when structural contains is nil' do
      let(:clazz) { Cocina::Models::DRO }
      let(:attributes) { { access: { view: 'dark' }, structural: {} } }

      it 'calls validate! without visiting any files' do
        validate
        expect(validator_instance).not_to have_received(:visit_file)
        expect(validator_instance).to have_received(:validate!).once
      end
    end

    context 'when structural is nil' do
      let(:clazz) { Cocina::Models::DRO }
      let(:attributes) { { access: { view: 'dark' } } }

      it 'calls validate! without visiting any files' do
        validate
        expect(validator_instance).not_to have_received(:visit_file)
        expect(validator_instance).to have_received(:validate!).once
      end
    end
  end
end
