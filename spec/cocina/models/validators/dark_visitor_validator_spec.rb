# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DarkVisitorValidator do
  subject(:validator) { described_class.new(attributes) }

  let(:attributes) { { access: { view: view } } }
  let(:view) { 'dark' }

  let(:file) do
    {
      filename: 'page1.txt',
      hasMimeType: mime_type,
      access: { view: file_view, download: 'none' },
      administrative: { publish: false, shelve: shelve, sdrPreserve: true }
    }
  end

  let(:file_view) { 'dark' }
  let(:shelve) { false }
  let(:mime_type) { 'text/plain' }

  def visit_and_validate
    validator.visit_file(file_hash: file)
    validator.validate!
  end

  context 'when dark object with valid file' do
    it 'does not raise' do
      expect { visit_and_validate }.not_to raise_error
    end
  end

  context 'when not a dark object' do
    let(:view) { 'world' }

    context 'when file would otherwise be invalid' do
      let(:shelve) { true }

      it 'does not raise' do
        expect { visit_and_validate }.not_to raise_error
      end
    end
  end

  context 'when dark and shelve is true' do
    let(:shelve) { true }

    context 'when not a WARC' do
      it 'raises' do
        expect { visit_and_validate }.to raise_error(
          Cocina::Models::ValidationError,
          'Not all files have dark access and/or are unshelved when object access is dark: ["page1.txt"]'
        )
      end
    end

    context 'when a WARC' do
      let(:mime_type) { 'application/warc' }

      it 'does not raise' do
        expect { visit_and_validate }.not_to raise_error
      end
    end
  end

  context 'when dark and file access is not dark' do
    let(:file_view) { 'world' }

    it 'raises' do
      expect { visit_and_validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when empty object access (defaults to dark)' do
    let(:attributes) { { access: {} } }

    context 'when file is valid' do
      it 'does not raise' do
        expect { visit_and_validate }.not_to raise_error
      end
    end

    context 'when file is invalid' do
      let(:shelve) { true }

      it 'raises' do
        expect { visit_and_validate }.to raise_error(Cocina::Models::ValidationError)
      end
    end
  end

  context 'when empty file access (defaults to dark)' do
    let(:file) do
      {
        filename: 'page1.txt',
        hasMimeType: 'text/plain',
        access: {},
        administrative: { publish: false, shelve: false, sdrPreserve: true }
      }
    end

    it 'does not raise' do
      expect { visit_and_validate }.not_to raise_error
    end
  end

  context 'when file has no filename, only label' do
    let(:shelve) { true }
    let(:file) do
      {
        label: 'Page 1',
        hasMimeType: 'text/plain',
        access: { view: 'dark' },
        administrative: { shelve: true }
      }
    end

    it 'uses label in error message' do
      expect { visit_and_validate }.to raise_error(
        Cocina::Models::ValidationError,
        /Page 1/
      )
    end
  end
end
