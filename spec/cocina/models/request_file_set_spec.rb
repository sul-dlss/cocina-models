# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::RequestFileSet do
  subject(:item) { described_class.new(properties) }

  let(:file_set_type) { 'http://cocina.sul.stanford.edu/models/fileset.jsonld' }

  describe 'initialization' do
    context 'with a minimal set' do
      let(:properties) do
        {
          type: file_set_type,
          label: 'My file',
          version: 3
        }
      end

      it 'has properties' do
        expect(item.type).to eq file_set_type
        expect(item.label).to eq 'My file'
      end
    end

    context 'with a string version' do
      let(:properties) do
        {
          type: file_set_type,
          label: 'My file',
          version: '3'
        }
      end

      it 'coerces to integer' do
        expect(item.version).to eq 3
      end
    end

    context 'with a all properties' do
      let(:properties) do
        {
          type: file_set_type,
          label: 'My file',
          version: 3,
          administrative: {
          },
          structural: {
            contains: [
              {
                type: Cocina::Models::Vocab.file,
                label: 'file#1',
                version: 3
              },
              {
                type: Cocina::Models::Vocab.file,
                label: 'file#2',
                version: 3
              }
            ]
          }
        }
      end

      it 'has properties' do
        expect(item.type).to eq file_set_type
        expect(item.label).to eq 'My file'

        expect(item.structural.contains).to all(be_instance_of(Cocina::Models::RequestFile))
      end
    end
  end
end
