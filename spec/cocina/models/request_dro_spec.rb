# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/dro_shared_examples.rb'

RSpec.describe Cocina::Models::RequestDRO do
  let(:item_type) { Cocina::Models::Vocab.object }
  let(:required_properties) do
    {
      label: 'My object',
      type: item_type,
      version: 7
    }
  end
  let(:struct_class) { Cocina::Models::RequestDROStructural }
  let(:struct_contains_class) { Cocina::Models::RequestFileSet }
  let(:struct_contains_properties) do
    [
      { type: file_set_type,
        version: 1,
        label: 'Resource #1',
        structural: {} },
      { type: file_set_type,
        version: 2,
        label: 'Resource #2',
        structural: {} }
    ]
  end

  it_behaves_like 'it has dro attributes'

  describe '#access' do
    context 'when no access values are passed in' do
      subject(:access) { instance.access }

      let(:instance) { described_class.new(required_properties) }

      it { is_expected.to be_nil }
    end

    context 'when access values are passed in' do
      subject(:access) { instance.access }

      let(:instance) { described_class.new(required_properties.merge(access: {})) }

      it { is_expected.to be_kind_of Cocina::Models::DROAccess }
    end
  end

  describe Cocina::Models::RequestDROStructural do
    context 'with RequestFileSet as contained class' do
      let(:instance) { described_class.new(properties) }
      let(:properties) do
        {
          contains: [
            struct_contains_class.new(
              label: 'requestfileset#1',
              type: Cocina::Models::Vocab.fileset,
              version: 1
            )
          ]
        }
      end

      it 'populates passed attrbutes for RequestFile' do
        expect(instance.contains).to all(be_kind_of(struct_contains_class))
        file1 = instance.contains.first
        expect(file1.type).to eq Cocina::Models::Vocab.fileset
        expect(file1.label).to eq 'requestfileset#1'
        expect(file1.version).to eq 1
      end
    end
  end
end
