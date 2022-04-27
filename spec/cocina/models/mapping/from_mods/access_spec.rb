# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Mapping::FromMods::Access do
  subject(:build) do
    described_class.build(resource_element: ng_xml.root, descriptive_builder: descriptive_builder)
  end

  let(:descriptive_builder) do
    instance_double(Cocina::Models::Mapping::FromMods::DescriptionBuilder, notifier: notifier)
  end

  let(:notifier) { instance_double(Cocina::Models::Mapping::ErrorNotifier) }

  let(:ng_xml) do
    Nokogiri::XML <<~XML
      <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://www.loc.gov/mods/v3" version="3.6"
        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
        #{xml}
      </mods>
    XML
  end

  context 'with a physical repository without authority and valueURI' do
    let(:xml) do
      <<~XML
        <location>
          <physicalLocation type="repository">Stanford University. Libraries. Department of Special Collections and University Archives</physicalLocation>
        </location>
      XML
    end

    it 'builds the cocina data structure' do
      expect(build).to eq(
        {
          accessContact: [
            {
              value: 'Stanford University. Libraries. Department of Special Collections and University Archives',
              type: 'repository'
            }
          ]
        }
      )
    end
  end

  context 'with a URL (without usage)' do
    let(:xml) do
      <<~XML
        <location>
          <url>https://www.davidrumsey.com/luna/servlet/view/search?q=pub_list_no=%2211728.000</url>
        </location>
      XML
    end

    it 'builds the cocina data structure' do
      expect(build).to eq(
        url: [
          {
            value: 'https://www.davidrumsey.com/luna/servlet/view/search?q=pub_list_no=%2211728.000'
          }
        ]
      )
    end
  end

  context 'with Physical location with display label - two location elements' do
    let(:xml) do
      <<~XML
        <location>
          <physicalLocation type="repository" displayLabel="Repository" authorityURI="http://id.loc.gov/authorities/names/" valueURI="http://id.loc.gov/authorities/names/no2014019980">Stanford University. Libraries. Department of Special Collections and University Archives</physicalLocation>
        </location>
        <location>
          <physicalLocation>Call Number: SC0340, Accession 2005-101, Box: 51, Folder: 3</physicalLocation>
        </location>
      XML
    end

    it 'builds the cocina data structure' do
      expect(build).to eq(
        accessContact: [
          {
            value: 'Stanford University. Libraries. Department of Special Collections and University Archives',
            uri: 'http://id.loc.gov/authorities/names/no2014019980',
            type: 'repository',
            displayLabel: 'Repository',
            source: {
              uri: 'http://id.loc.gov/authorities/names/'
            }
          }
        ],
        physicalLocation: [
          {
            value: 'Call Number: SC0340, Accession 2005-101, Box: 51, Folder: 3'
          }
        ]
      )
    end
  end

  # https://github.com/sul-dlss-labs/cocina-descriptive-metadata/issues/256
  context 'with a displayLabel' do
    let(:xml) do
      <<~XML
        <accessCondition displayLabel="CC License Type" type='license'>CC by: CC BY Attribution</accessCondition>
      XML
    end

    it 'builds the cocina data structure' do
      expect(build).to eq(
        {
          note: [
            {
              value: 'CC by: CC BY Attribution',
              displayLabel: 'CC License Type',
              type: 'license'
            }
          ]
        }
      )
    end
  end
end
