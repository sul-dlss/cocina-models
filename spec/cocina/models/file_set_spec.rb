# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/file_set_shared_examples.rb'

RSpec.describe Cocina::Models::FileSet do
  let(:file_set_type) { Cocina::Models::Vocab.fileset }
  let(:required_properties) do
    {
      externalIdentifier: 'druid:ab123cd4567',
      label: 'My fileset',
      type: file_set_type,
      version: 3
    }
  end
  let(:struct_class) { Cocina::Models::FileSetStructural }
  let(:struct_contains_class) { Cocina::Models::File }

  it_behaves_like 'it has file_set attributes'

  context 'when externalIdentifier is missing' do
    let(:fileset) { described_class.new(required_properties.reject { |k, _v| k == :externalIdentifier }) }

    it 'raises a Dry::Struct::Error' do
      err_msg = '[Cocina::Models::FileSet.new] :externalIdentifier is missing in Hash input'
      expect { fileset }.to raise_error(Dry::Struct::Error, err_msg)
    end
  end

  describe 'Checkable model methods' do
    subject { described_class.new(required_properties) }

    it { is_expected.not_to be_admin_policy }
    it { is_expected.not_to be_collection }
    it { is_expected.not_to be_dro }
    it { is_expected.not_to be_file }
    it { is_expected.to be_file_set }
  end

  describe Cocina::Models::FileSetStructural do
    let(:instance) { described_class.new(properties) }

    context 'with File as contained class' do
      let(:properties) do
        {
          contains: [
            struct_contains_class.new(
              externalIdentifier: 'file#1',
              label: 'file#1',
              type: Cocina::Models::Vocab.file,
              version: 1
            )
          ]
        }
      end

      it 'populates passed attrbutes for File' do
        expect(instance.contains).to all(be_kind_of(struct_contains_class))
        file1 = instance.contains.first
        expect(file1.type).to eq Cocina::Models::Vocab.file
        expect(file1.label).to eq 'file#1'
        expect(file1.version).to eq 1
        expect(file1.externalIdentifier).to eq 'file#1'
      end
    end

    context 'with RequestFile as contained class' do
      let(:properties) do
        {
          contains: [
            Cocina::Models::RequestFile.new(
              label: 'requestfile#1',
              type: Cocina::Models::Vocab.file,
              version: 1
            )
          ]
        }
      end

      it 'raises a Dry::Struct::Error' do
        expect { instance }.to raise_error(Dry::Struct::Error)
      end
    end
  end
end
