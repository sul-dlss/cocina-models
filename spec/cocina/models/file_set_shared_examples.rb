# frozen_string_literal: true

require 'spec_helper'

# These shared_examples are meant to be used by FileSet and RequestFileSet specs in
# order to de-dup test code for all the functionality they have in common.
# The caller MUST define:
# - required_properties
#    (a hash containing the minimal required properties that must be provided to (Request)FileSet.new)
# - struct_class: the class used for the structural attribute (different between FileSet and RequestFileSet)
# - struct_contains_class: the class used for the members of the contains attribute
#     in the structural attribute (in practice, Cocina::Models::File or Cocina::Models::RequestFile)
RSpec.shared_examples 'it has file_set attributes' do
  let(:instance) { described_class.new(properties) }
  let(:file_set_type) { Cocina::Models::Vocab.fileset }
  # see block comment for info about required_properties
  let(:properties) { required_properties }

  describe 'initialization' do
    context 'with minimal required properties provided' do
      it 'populates required attributes passed in' do
        if required_properties[:externalIdentifier]
          expect(instance.externalIdentifier).to eq required_properties[:externalIdentifier]
        end
        expect(instance.label).to eq required_properties[:label]
        expect(instance.type).to eq required_properties[:type]
        expect(instance.version).to eq required_properties[:version]
      end

      it 'populates non-passed required attributes with default values' do
        expect(instance.identification).to be_kind_of Cocina::Models::FileSet::Identification
        expect(instance.identification.attributes.size).to eq 0

        expect(instance.structural).to be_kind_of struct_class
        expect(instance.structural.attributes.size).to eq 0
      end
    end

    context 'with a string version property' do
      let(:properties) { required_properties.merge(version: required_properties[:version].to_s) }

      it 'coerces to integer' do
        expect(instance.version).to eq required_properties[:version]
      end
    end

    context 'with all specifiable properties' do
      let(:properties) do
        required_properties.merge(
          identification: {},
          structural: {
            contains: [
              struct_contains_class.new(
                type: Cocina::Models::Vocab.file,
                label: 'file#1',
                version: 1,
                externalIdentifier: 'file#1'
              ),
              struct_contains_class.new(
                type: Cocina::Models::Vocab.file,
                label: 'file#2',
                version: 2,
                externalIdentifier: 'file#2'
              )
            ]
          }
        )
      end

      it 'populates all attributes passed in' do
        expect(instance.identification).to be_kind_of Cocina::Models::FileSet::Identification
        expect(instance.identification.attributes.size).to eq 0

        expect(instance.structural).to be_kind_of struct_class
        struct_contains = instance.structural.contains
        expect(struct_contains).to all(be_kind_of(struct_contains_class))
        expect(struct_contains.size).to eq 2
        file1 = struct_contains.first
        expect(file1.type).to eq Cocina::Models::Vocab.file
        expect(file1.label).to eq 'file#1'
        expect(file1.version).to eq 1
        file2 = struct_contains.last
        expect(file2.type).to eq Cocina::Models::Vocab.file
        expect(file2.label).to eq 'file#2'
        expect(file2.version).to eq 2
        if required_properties[:externalIdentifier]
          expect(file1.externalIdentifier).to eq 'file#1'
          expect(file2.externalIdentifier).to eq 'file#2'
        end
      end
    end

    context 'with empty properties that have default values' do
      let(:properties) do
        required_properties.merge(
          identification: {},
          structural: {}
        )
      end

      it 'uses default values' do
        expect(instance.identification).to be_kind_of Cocina::Models::FileSet::Identification
        expect(instance.identification.attributes.size).to eq 0

        expect(instance.structural).to be_kind_of struct_class
        expect(instance.structural.attributes.size).to eq 0
      end
    end
  end
end
