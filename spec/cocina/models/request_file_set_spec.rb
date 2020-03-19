# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/file_set_shared_examples.rb'

RSpec.describe Cocina::Models::RequestFileSet do
  let(:file_set_type) { Cocina::Models::Vocab.fileset }
  let(:required_properties) do
    {
      label: 'My fileset',
      type: file_set_type,
      version: 3
    }
  end
  let(:struct_class) { Cocina::Models::RequestFileSetStructural }
  let(:struct_contains_class) { Cocina::Models::RequestFile }

  it_behaves_like 'it has file_set attributes'

  describe Cocina::Models::RequestFileSetStructural do
    context 'with RequestFile as contained class' do
      let(:instance) { described_class.new(properties) }
      let(:properties) do
        {
          contains: [
            struct_contains_class.new(
              label: 'requestfile#1',
              filename: 'requestfile.txt',
              type: Cocina::Models::Vocab.file,
              version: 1
            )
          ]
        }
      end

      it 'populates passed attrbutes for RequestFile' do
        expect(instance.contains).to all(be_kind_of(struct_contains_class))
        file1 = instance.contains.first
        expect(file1.type).to eq Cocina::Models::Vocab.file
        expect(file1.label).to eq 'requestfile#1'
        expect(file1.version).to eq 1
      end
    end

    context 'with File as contained class' do
      let(:instance) { described_class.new(properties) }
      let(:properties) do
        {
          contains: [
            Cocina::Models::File.new(
              externalIdentifier: 'file#1',
              label: 'file#1',
              filename: 'file1.txt',
              type: Cocina::Models::Vocab.file,
              version: 1
            )
          ]
        }
      end

      # I expected a Dry::Struct::Error to be raised
      it 'coerces it to RequestFile' do
        expect(instance.contains).to all(be_kind_of(struct_contains_class))
        file1 = instance.contains.first
        expect(file1.type).to eq Cocina::Models::Vocab.file
        expect(file1.label).to eq 'file#1'
        expect(file1.version).to eq 1
      end
    end
  end
end
