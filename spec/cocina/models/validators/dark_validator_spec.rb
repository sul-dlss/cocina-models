# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DarkValidator do
  let(:validate) { described_class.validate(clazz, props) }

  let(:clazz) { Cocina::Models::DRO }

  let(:props) { dro_props }

  let(:dro_props) do
    {
      type: Cocina::Models::ObjectType.book,
      access: obj_access,
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
                  access: file_access,
                  administrative: {
                    publish: publish,
                    shelve: shelve,
                    sdrPreserve: true
                  },
                  hasMessageDigests: [],
                  hasMimeType: mime_type,
                  filename: 'page1.txt' }
              ]
            }
          }
        ]
      }
    }
  end

  let(:obj_access) do
    { view: view, download: 'none' }
  end

  let(:file_access) do
    { view: file_view, download: 'none' }
  end

  let(:request_dro_props) do
    dro_props.dup.tap do |props|
      props[:structural][:contains][0].delete(:externalIdentifier)
      props[:structural][:contains][0][:structural][:contains].delete(:externalIdentifier)
    end
  end

  let(:view) { 'dark' }
  let(:file_view) { 'dark' }
  let(:publish) { false }
  let(:shelve) { false }
  let(:mime_type) { 'text/plain' }

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

  context 'when an invalid RequestDRO' do
    let(:props) { request_dro_props }
    let(:clazz) { Cocina::Models::RequestDRO }
    let(:shelve) { true }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when an invalid DROWithMetadata' do
    let(:clazz) { Cocina::Models::DROWithMetadata }
    let(:shelve) { true }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when not dark' do
    let(:view) { 'world' }

    it 'is valid' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when dark and shelve is true' do
    let(:shelve) { true }

    context 'when not a WARC' do
      it 'is not valid' do
        expect { validate }.to raise_error(
          Cocina::Models::ValidationError,
          'Not all files have dark access and/or are unshelved when object access is dark: ["page1.txt"]'
        )
      end
    end

    context 'when a WARC' do
      let(:mime_type) { 'application/warc' }

      it 'is valid' do
        expect { validate }.not_to raise_error
      end
    end
  end

  context 'when dark and publish is true' do
    let(:publish) { true }

    it 'is valid' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when empty object access' do
    # Empty access defaults to dark
    let(:obj_access) { {} }

    context 'when valid' do
      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when invalid' do
      let(:shelve) { true }

      it 'raise' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError)
      end
    end
  end

  context 'when empty file access' do
    # Empty access defaults to dark
    let(:file_access) { {} }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end
end
