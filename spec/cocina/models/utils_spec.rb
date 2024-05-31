# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Utils do
  describe '.files' do
    subject(:files) { described_class.files(dro) }

    let(:dro) do
      build(:dro).new(
        structural: {
          contains: [
            {
              externalIdentifier: 'bc123df4567_1',
              label: 'Fileset 1',
              type: Cocina::Models::FileSetType.file,
              version: 1,
              structural: {
                contains: [
                  {
                    externalIdentifier: 'bc123df4567_1',
                    label: 'Page 1',
                    type: Cocina::Models::ObjectType.file,
                    version: 1,
                    filename: 'page1.txt'
                  }
                ]
              }
            },
            {
              externalIdentifier: 'bc123df4567_2',
              label: 'Fileset 2',
              type: Cocina::Models::FileSetType.file,
              version: 1,
              structural: {
                contains: [
                  {
                    externalIdentifier: 'bc123df4567_1',
                    label: 'Page 2',
                    type: Cocina::Models::ObjectType.file,
                    version: 1,
                    filename: 'page2.txt'
                  }
                ]
              }
            }
          ]
        }
      )
    end

    it 'returns a list of files' do
      expect(files).to all(be_a Cocina::Models::File)
      expect(files.map(&:filename)).to eq ['page1.txt', 'page2.txt']
    end
  end
end
