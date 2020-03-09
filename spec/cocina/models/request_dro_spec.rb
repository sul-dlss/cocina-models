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
  let(:struct_class) { Cocina::Models::RequestDRO::Structural }
  let(:struct_contains_class) { Cocina::Models::RequestFileSet }

  it_behaves_like 'it has dro attributes'

  describe Cocina::Models::RequestDRO::Structural do
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

    context 'with FileSet as contained class' do
      let(:instance) { described_class.new(properties) }
      let(:properties) do
        {
          contains: [
            Cocina::Models::FileSet.new(
              externalIdentifier: 'fileset#2',
              label: 'fileset#2',
              type: Cocina::Models::Vocab.fileset,
              version: 2
            )
          ]
        }
      end

      # I expected a Dry::Struct::Error to be raised
      it 'coerces it to RequestFileSet' do
        expect(instance.contains).to all(be_kind_of(struct_contains_class))
        fileset1 = instance.contains.first
        expect(fileset1.type).to eq Cocina::Models::Vocab.fileset
        expect(fileset1.label).to eq 'fileset#2'
        expect(fileset1.version).to eq 2
      end
    end
  end
end
