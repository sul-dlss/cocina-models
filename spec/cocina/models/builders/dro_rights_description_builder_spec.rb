# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Builders::DroRightsDescriptionBuilder do
  subject(:builder_build) { described_class.build(cocina_object) }

  let(:structural) { {} }
  let(:cocina_object) do
    build(:dro).new(access: access, structural: structural)
  end

  context 'when access is limited by controlled digital lending' do
    let(:access) { { controlledDigitalLending: true, view: 'stanford', download: 'none' } }

    it 'returns the controlled digital lending rights description' do
      expect(builder_build).to eq('controlled digital lending')
    end
  end

  context 'with access world/world' do
    let(:access) { { view: 'world', download: 'world' } }

    it 'returns the world rights description' do
      expect(builder_build).to eq(['world'])
    end
  end

  context 'with access world/none' do
    let(:access) { { view: 'world', download: 'none' } }

    it 'returns the world (no-download) rights description' do
      expect(builder_build).to eq(['world (no-download)'])
    end
  end

  context 'with access world/stanford' do
    let(:access) { { view: 'world', download: 'stanford' } }

    it 'returns the world (no-download) rights description' do
      expect(builder_build).to eq(['stanford', 'world (no-download)'])
    end
  end

  context 'with access world/location-based' do
    let(:access) { { view: 'world', download: 'location-based', location: 'm&m' } }

    it 'returns the world (no-download) and location rights description' do
      expect(builder_build).to eq(['world (no-download)', 'location: m&m'])
    end
  end

  context 'with access citation-only/none' do
    let(:access) { { view: 'citation-only', download: 'none' } }

    it 'returns the citation rights description' do
      expect(builder_build).to eq(['citation'])
    end
  end

  context 'with access location-based/none' do
    let(:access) { { view: 'location-based', download: 'none', location: 'm&m' } }

    it 'returns the location (no-download) rights description' do
      expect(builder_build).to eq(['location: m&m (no-download)'])
    end
  end

  context 'with access stanford/location-based' do
    let(:access) { { view: 'stanford', download: 'location-based', location: 'm&m' } }

    it 'returns the stanford (no-download) and location rights description' do
      expect(builder_build).to eq(['stanford (no-download)', 'location: m&m'])
    end
  end

  context 'with file level access' do
    let(:access) { { view: 'world', download: 'world' } }
    let(:structural) do
      {
        contains: [
          {
            version: 1,
            type: 'https://cocina.sul.stanford.edu/models/resources/file',
            label: 'Page 1',
            externalIdentifier: 'abc123',
            structural: {
              contains: [
                {
                  version: 1,
                  type: 'https://cocina.sul.stanford.edu/models/file',
                  filename: '00002.jp2',
                  label: '00002.jp2',
                  hasMimeType: 'image/jp2',
                  externalIdentifier: 'abc123',
                  size: 111_467,
                  administrative: {
                    publish: true,
                    sdrPreserve: true,
                    shelve: true
                  },
                  access: {
                    view: 'stanford',
                    download: 'stanford'
                  },
                  hasMessageDigests: []
                }
              ]
            }
          }
        ]
      }
    end

    it 'returns to the rights description with file access included' do
      expect(builder_build).to eq(['world', 'stanford (file)'])
    end
  end
end
