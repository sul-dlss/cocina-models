# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Builders::RightsDescriptionBuilder do
  subject(:builder_build) { described_class.build(cocina_object) }

  let(:cocina_object) do
    build(:admin_policy).new(
      administrative: {
        hasAdminPolicy: 'druid:bc123df4567',
        hasAgreement: 'druid:bc123df4567',
        accessTemplate: access_template
      }
    )
  end

  context 'when access is limited by controlled digital lending' do
    let(:access_template) { { controlledDigitalLending: true, view: 'world', download: 'world' } }

    it 'returns the controlled digital lending rights description' do
      expect(builder_build).to eq('controlled digital lending')
    end
  end

  context 'with access world/world' do
    let(:access_template) { { view: 'world', download: 'world' } }

    it 'returns the world rights description' do
      expect(builder_build).to eq(['world'])
    end
  end

  context 'with access world/none' do
    let(:access_template) { { view: 'world', download: 'none' } }

    it 'returns the world (no-download) rights description' do
      expect(builder_build).to eq(['world (no-download)'])
    end
  end

  context 'with access world/stanford' do
    let(:access_template) { { view: 'world', download: 'stanford' } }

    it 'returns the world (no-download) rights description' do
      expect(builder_build).to eq(['stanford', 'world (no-download)'])
    end
  end

  context 'with access world/location-based' do
    let(:access_template) { { view: 'world', download: 'location-based', location: 'm&m' } }

    it 'returns the world (no-download) and location rights description' do
      expect(builder_build).to eq(['world (no-download)', 'location: m&m'])
    end
  end

  context 'with access citation-only/none' do
    let(:access_template) { { view: 'citation-only', download: 'none' } }

    it 'returns the citation rights description' do
      expect(builder_build).to eq(['citation'])
    end
  end

  context 'with access location-based/none' do
    let(:access_template) { { view: 'location-based', download: 'none', location: 'm&m' } }

    it 'returns the location (no-download) rights description' do
      expect(builder_build).to eq(['location: m&m (no-download)'])
    end
  end

  context 'with access location-based/world' do
    let(:access_template) { { view: 'location-based', download: 'world', location: 'm&m' } }

    it 'returns the location rights description' do
      expect(builder_build).to eq(['location: m&m'])
    end
  end

  context 'with access stanford/none' do
    let(:access_template) { { view: 'stanford', download: 'none' } }

    it 'returns the stanford (no-download) rights description' do
      expect(builder_build).to eq(['stanford (no-download)'])
    end
  end

  context 'with access stanford/location-based' do
    let(:access_template) { { view: 'stanford', download: 'location-based', location: 'm&m' } }

    it 'returns the stanford (no-download) and location rights description' do
      expect(builder_build).to eq(['stanford (no-download)', 'location: m&m'])
    end
  end

  context 'with access stanford/world' do
    let(:access_template) { { view: 'stanford', download: 'world' } }

    it 'returns the stanford rights description' do
      expect(builder_build).to eq(['stanford'])
    end
  end
end
