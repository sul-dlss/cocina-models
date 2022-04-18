# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::CdlValidator do
  let(:validate) { described_class.validate(clazz, props) }

  let(:clazz) { Cocina::Models::DRO }

  let(:props) { dro_props }
  let(:cdl) { true }

  let(:dro_props) do
    {
      type: Cocina::Models::ObjectType.book,
      access: { view: view, download: download, controlledDigitalLending: cdl },
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
                  access: { view: 'stanford', download: 'none' },
                  administrative: {
                    publish: true,
                    shelve: true,
                    sdrPreserve: true
                  },
                  hasMessageDigests: [],
                  hasMimeType: 'text/plain',
                  filename: 'page1.txt' }
              ]
            }
          }
        ]
      }
    }
  end

  describe 'when access is stanford and download is none' do
    let(:view) { 'stanford' }
    let(:download) { 'none' }

    describe 'when controlledDigitalLending is missing' do
      let(:missing_cdl_props) do
        dro_props.dup.tap do |props|
          props[:access].delete(:controlledDigitalLending)
        end
      end

      let(:props) { missing_cdl_props }

      it 'is not valid' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    describe 'when controlledDigitalLending is set to true' do
      it 'does not raise' do
        validate
      end
    end

    describe 'when controlledDigitalLending is set to false' do
      let(:cdl) { false }

      it 'does not raise' do
        validate
      end
    end

    describe 'when controlledDigitalLending exists but is set to nil' do
      let(:cdl) { nil }

      it 'is not valid' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError)
      end
    end
  end

  describe 'when access is not stanford' do
    let(:view) { 'world' }
    let(:download) { 'none' }

    describe 'when controlledDigitalLending is missing' do
      let(:missing_cdl_props) do
        dro_props.dup.tap do |props|
          props[:access].delete(:controlledDigitalLending)
        end
      end

      let(:props) { missing_cdl_props }

      it 'does not raise' do
        validate
      end
    end

    describe 'when controlledDigitalLending is set to true' do
      it 'does not raise' do
        validate
      end
    end

    describe 'when controlledDigitalLending is set to false' do
      let(:cdl) { false }

      it 'does not raise' do
        validate
      end
    end

    describe 'when controlledDigitalLending exists but is set to nil' do
      let(:cdl) { nil }

      it 'does not raise' do
        validate
      end
    end
  end
end
