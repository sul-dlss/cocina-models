# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::LanguageTagVisitorValidator do
  subject(:validator) { described_class.new(attributes) }

  let(:attributes) { {} }

  let(:file) do
    {
      filename: 'page1.txt',
      languageTag: language_tag
    }
  end

  def visit_and_validate
    validator.visit_file(file_hash: file)
    validator.validate!
  end

  context 'with no languageTag' do
    let(:file) { { filename: 'page1.txt' } }

    it 'does not raise' do
      expect { visit_and_validate }.not_to raise_error
    end
  end

  context 'with RFC 4646 conformant languageTag' do
    context 'with a recognized language, script, and region' do
      let(:language_tag) { 'ru-Cyrl-RU' }

      it 'does not raise' do
        expect { visit_and_validate }.not_to raise_error
      end
    end

    context 'with an unrecognized language, script, and region' do
      let(:language_tag) { 'foo-Barr-BZ' } # still conforms to the expected format of BCP 47/RFC 4646, should parse

      it 'does not raise' do
        expect { visit_and_validate }.not_to raise_error
      end
    end
  end

  context 'with languageTag that does not conform to RFC 4646' do
    let(:language_tag) { 'fooooooooooooo' }

    it 'raises a validation error' do
      expect { visit_and_validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Some files have invalid language tags according to RFC 4646: page1.txt (fooooooooooooo)'
      )
    end
  end

  context 'when file has no filename, only label' do
    let(:file) { { label: 'Page 1', languageTag: 'fooooooooooooo' } }

    it 'uses label in error message' do
      expect { visit_and_validate }.to raise_error(
        Cocina::Models::ValidationError,
        /Page 1 \(fooooooooooooo\)/
      )
    end
  end

  context 'with multiple files, some invalid' do
    let(:file_valid) { { filename: 'valid.txt', languageTag: 'en' } }
    let(:file_invalid) { { filename: 'bad.txt', languageTag: 'fooooooooooooo' } }

    it 'reports all invalid files' do
      validator.visit_file(file_hash: file_valid)
      validator.visit_file(file_hash: file_invalid)
      expect { validator.validate! }.to raise_error(
        Cocina::Models::ValidationError,
        'Some files have invalid language tags according to RFC 4646: bad.txt (fooooooooooooo)'
      )
    end
  end
end
