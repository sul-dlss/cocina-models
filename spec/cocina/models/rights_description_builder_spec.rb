# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::RightsDescriptionBuilder do
  let(:cocina_apo) do
    Cocina::Models::AdminPolicy.new(externalIdentifier: 'druid:bc123dg9393',
                                    administrative: {
                                      hasAdminPolicy: 'druid:gg123vx9393',
                                      hasAgreement: 'druid:bb008zm4587',
                                      accessTemplate: access_template
                                    },
                                    version: 1,
                                    label: 'just an apo',
                                    type: Cocina::Models::ObjectType.admin_policy)
  end

  context 'when the access template inlcudes view: world' do
    context 'with download: world' do
      let(:access_template) { { view: 'world', download: 'world' } }

      it 'returns world' do
        expect(cocina_apo.object_access).to eq(['world'])
      end
    end

    context 'with download: stanford' do
      let(:access_template) { { view: 'world', download: 'stanford' } }

      it 'returns stanford, world (no-download)' do
        expect(cocina_apo.object_access).to eq(['stanford', 'world (no-download)'])
      end
    end

    context 'with download: none' do
      let(:access_template) { { view: 'world', download: 'none' } }

      it 'returns world (no-download)' do
        expect(cocina_apo.object_access).to eq(['world (no-download)'])
      end
    end

    context 'with download: location-based' do
      let(:access_template) { { view: 'world', download: 'location-based', location: 'm&m' } }

      it 'returns world (no-download)' do
        expect(cocina_apo.object_access).to eq(['world (no-download)', 'location: m&m'])
      end
    end
  end

  context 'when the access template includes view: stanford' do
    context 'with download: stanford' do
      let(:access_template) { { view: 'stanford', download: 'stanford' } }

      it 'returns stanford (no-download)' do
        expect(cocina_apo.object_access).to eq(['stanford'])
      end
    end

    context 'with download: none' do
      let(:access_template) { { view: 'stanford', download: 'none' } }

      it 'returns stanford (no-download)' do
        expect(cocina_apo.object_access).to eq(['stanford (no-download)'])
      end
    end

    context 'with download: location-based' do
      let(:access_template) { { view: 'stanford', download: 'location-based', location: 'm&m' } }

      it 'returns world (no-download)' do
        expect(cocina_apo.object_access).to eq(['stanford (no-download)', 'location: m&m'])
      end
    end
  end

  context 'when the access template includes view: citation-only' do
    let(:access_template) { { view: 'citation-only', download: 'none' } }

    it 'returns citation' do
      expect(cocina_apo.object_access).to eq(['citation'])
    end
  end

  context 'when the access template includes view: location-based' do
    context 'with download: none' do
      let(:access_template) { { view: 'location-based', download: 'none', location: 'm&m' } }

      it 'returns location: m&m (no-download)' do
        expect(cocina_apo.object_access).to eq(['location: m&m (no-download)'])
      end
    end

    context 'with download: world' do
      let(:access_template) { { view: 'location-based', download: 'world', location: 'm&m' } }

      it 'returns location: m&m' do
        expect(cocina_apo.object_access).to eq(['location: m&m'])
      end
    end
  end

  context 'when the access template includes view: dark' do
    let(:access_template) { { view: 'dark', download: 'none' } }

    it 'returns dark' do
      expect(cocina_apo.object_access).to eq(['dark'])
    end
  end

  context 'when the access template includes controlledDigitalLending: true' do
    let(:access_template) { { controlledDigitalLending: true, view: 'dark', download: 'none' } }

    it 'returns dark' do
      expect(cocina_apo.object_access).to eq('controlled digital lending')
    end
  end
end
