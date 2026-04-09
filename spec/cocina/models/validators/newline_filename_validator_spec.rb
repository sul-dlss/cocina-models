# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::NewlineFilenameValidator do
  let(:validate) { described_class.validate(clazz, props) }

  let(:clazz) { Cocina::Models::DRO }

  let(:props) { dro_props }

  let(:dro_props) do
    {
      externalIdentifier: 'druid:bc123df4567',
      type: Cocina::Models::ObjectType.book,
      access: { view: 'public', download: 'none' },
      structural: {
        contains: [
          {
            externalIdentifier: 'bc123df4567_1',
            label: 'Fileset 1',
            type: Cocina::Models::FileSetType.file,
            version: 1,
            structural: {
              contains: [
                { externalIdentifier: 'bc123df4567_1',
                  label: 'Page 1',
                  type: Cocina::Models::ObjectType.file,
                  version: 1,
                  access: { view: 'public', download: 'none' },
                  administrative: {
                    publish: true,
                    shelve: true,
                    sdrPreserve: true
                  },
                  hasMessageDigests: [],
                  hasMimeType: 'text/plain',
                  filename: filename }
              ]
            }
          }
        ]
      }
    }
  end

  let(:filename) { 'test.txt' }

  context 'when a valid DRO' do
    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when filename contains spaces' do
    let(:filename) { 'my file.txt' }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when filename contains special characters but no newline' do
    let(:filename) { 'file (1).txt' }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when not a DRO' do
    let(:props) { {} }
    let(:clazz) { Cocina::Models::Identification }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when filename contains a newline character' do
    let(:filename) { "file\nname.txt" }

    it 'is not valid and includes the filename in the error' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError, /file\\nname\.txt/)
    end
  end

  context 'when filename contains a carriage return and newline' do
    let(:filename) { "file\r\nname.txt" }

    it 'is not valid and includes the filename in the error' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError, /file\\r\\nname\.txt/)
    end
  end

  context 'when filename is only a newline' do
    let(:filename) { "\n" }

    it 'is not valid and includes the filename in the error' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError, /\\n/)
    end
  end

  context 'when a valid DROWithMetadata' do
    let(:clazz) { Cocina::Models::DROWithMetadata }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when a DROWithMetadata has a newline in filename' do
    let(:clazz) { Cocina::Models::DROWithMetadata }
    let(:filename) { "file\nname.txt" }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end
end
