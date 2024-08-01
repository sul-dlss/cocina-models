# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::ReservedFilenameValidator do
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
                  access: {view: 'public', download: 'none'},
                  administrative: {
                    publish: true,
                    shelve: true,
                    sdrPreserve: true
                  },
                  hasMessageDigests: [],
                  hasMimeType: 'text/plain',
                  filename: filename}
              ]
            }
          }
        ]
      }
    }
  end

  let(:filename) { 'test.txt' }

  let(:request_dro_props) do
    dro_props.dup.tap do |props|
      props.delete(:externalIdentifier)
      props[:structural][:contains][0].delete(:externalIdentifier)
      props[:structural][:contains][0][:structural][:contains].delete(:externalIdentifier)
    end
  end

  context 'when a valid DRO' do
    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when a valid RequestDRO' do
    let(:props) { request_dro_props }
    let(:clazz) { Cocina::Models::RequestDRO }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when a valid DROWithMetadata' do
    let(:clazz) { Cocina::Models::DROWithMetadata }

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

  context 'when an invalid DRO' do
    let(:filename) { 'bc123df4567' }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when an invalid DROWithMetadata' do
    let(:clazz) { Cocina::Models::DROWithMetadata }

    let(:filename) { 'bc123df4567' }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when base dir is bare druid' do
    let(:filename) { 'bc123df4567/file1.txt' }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when child dir is bare druid' do
    let(:filename) { 'files/bc123df4567/file1.txt' }

    it 'is valid' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when non-root file is bare druid' do
    let(:filename) { 'files/bc123df4567' }

    it 'is valid' do
      expect { validate }.not_to raise_error
    end
  end
end
