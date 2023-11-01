# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::LanguageTagValidator do
  let(:validate) { described_class.validate(clazz, props) }

  let(:props) { file_props }

  let(:file_props) do
    {
      externalIdentifier: 'bc123df4567_1',
      label: 'Page 1',
      type: Cocina::Models::ObjectType.file,
      version: 1,
      access: { view: 'dark', download: 'none' },
      administrative: {
        publish: false,
        shelve: false,
        sdrPreserve: true
      },
      hasMessageDigests: [],
      hasMimeType: 'text/plain',
      filename: 'page1.txt'
    }
  end

  context 'with no value for languageTag specified' do
    context 'with a File' do
      let(:clazz) { Cocina::Models::File }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'with a RequestFile' do
      let(:clazz) { Cocina::Models::RequestFile }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end
  end

  context 'with RFC 4646 conformant value for languageTag specified' do
    let(:props) do
      file_props.dup.tap do |props|
        props[:languageTag] = language_tag
      end
    end

    context 'with a recognized language, script, and region' do
      let(:language_tag) { 'ru-Cyrl-RU' }

      context 'with a File' do
        let(:clazz) { Cocina::Models::File }

        it 'does not raise' do
          expect { validate }.not_to raise_error
        end
      end

      context 'with a RequestFile' do
        let(:clazz) { Cocina::Models::RequestFile }

        it 'does not raise' do
          expect { validate }.not_to raise_error
        end
      end
    end

    context 'with an unrecognized language, script, and region' do
      let(:language_tag) { 'foo-Barr-BZ' } # still conforms to the expected format of BCP 47/RFC 4646, should parse

      context 'with a File' do
        let(:clazz) { Cocina::Models::File }

        it 'does not raise' do
          expect { validate }.not_to raise_error
        end
      end

      context 'with a RequestFile' do
        let(:clazz) { Cocina::Models::RequestFile }

        it 'does not raise' do
          expect { validate }.not_to raise_error
        end
      end
    end
  end

  context 'with value for languageTag specified that does not conform to RFC 4646' do
    let(:props) do
      file_props.dup.tap do |props|
        props[:languageTag] = 'fooooooooooooo'
      end
    end

    context 'with a File' do
      let(:clazz) { Cocina::Models::File }

      it 'raises a validation error' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError, 'The provided language tag is not valid according to RFC 4646: fooooooooooooo')
      end
    end

    context 'with a RequestFile' do
      let(:clazz) { Cocina::Models::RequestFile }

      it 'raises a validation error' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError, 'The provided language tag is not valid according to RFC 4646: fooooooooooooo')
      end
    end
  end
end
