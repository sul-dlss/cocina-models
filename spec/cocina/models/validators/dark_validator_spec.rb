# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DarkValidator do
  let(:validate) { described_class.validate(clazz, props) }

  let(:clazz) { Cocina::Models::DRO }

  let(:props) { dro_props }

  let(:dro_props) do
    {
      type: Cocina::Models::ObjectType.book,
      access: { view: view, download: 'none' },
      structural: {
        contains: [
          {
            external_identifier: 'bc123df4567_1',
            label: 'Fileset 1',
            type: Cocina::Models::FileSetType.file,
            version: 1,
            structural: {
              contains: [
                { external_identifier: 'bc123df4567_1',
                  label: 'Page 1',
                  type: Cocina::Models::ObjectType.file,
                  version: 1,
                  access: { view: file_view, download: 'none' },
                  administrative: {
                    publish: publish,
                    shelve: shelve,
                    sdr_preserve: true
                  },
                  has_message_digests: [],
                  has_mime_type: mime_type,
                  filename: 'page1.txt' }
              ]
            }
          }
        ]
      }
    }
  end

  let(:request_dro_props) do
    dro_props.dup.tap do |props|
      props[:structural][:contains][0].delete(:external_identifier)
      props[:structural][:contains][0][:structural][:contains].delete(:external_identifier)
    end
  end

  let(:view) { 'dark' }
  let(:file_view) { 'dark' }
  let(:publish) { false }
  let(:shelve) { false }
  let(:mime_type) { 'text/plain' }

  describe 'when a valid DRO' do
    it 'does not raise' do
      validate
    end
  end

  describe 'when a valid RequestDRO' do
    let(:props) { request_dro_props }
    let(:clazz) { Cocina::Models::RequestDRO }

    it 'does not raise' do
      validate
    end
  end

  describe 'when a valid DROWithMetadata' do
    let(:clazz) { Cocina::Models::DROWithMetadata }

    it 'does not raise' do
      validate
    end
  end

  describe 'when not a DRO' do
    let(:props) { {} }
    let(:clazz) { Cocina::Models::Identification }

    it 'does not raise' do
      validate
    end
  end

  describe 'when an invalid RequestDRO' do
    let(:props) { request_dro_props }
    let(:clazz) { Cocina::Models::RequestDRO }
    let(:shelve) { true }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'when an invalid DROWithMetadata' do
    let(:clazz) { Cocina::Models::DROWithMetadata }
    let(:shelve) { true }

    it 'is not valid' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when not dark' do
    let(:view) { 'world' }

    it 'is valid' do
      validate
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
        validate
      end
    end
  end

  context 'when dark and publish is true' do
    let(:publish) { true }

    it 'is valid' do
      validate
    end
  end
end
