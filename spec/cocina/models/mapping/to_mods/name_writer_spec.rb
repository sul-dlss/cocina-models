# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Mapping::ToMods::NameWriter do
  subject(:xml) { writer.to_xml }

  let(:writer) do
    Nokogiri::XML::Builder.new do |xml|
      xml.mods('xmlns' => 'http://www.loc.gov/mods/v3',
               'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
               'version' => '3.6',
               'xsi:schemaLocation' => 'http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd') do
        described_class.write(xml: xml, contributor: contributor, id_generator: id_generator)
      end
    end
  end
  let(:id_generator) { nil }

  context 'when a contributor affiliation exists' do
    let(:contributor) do
      Cocina::Models::Contributor.new(
        {
          name: [
            {
              value: 'Schmedders, Karl'
            }
          ],
          type: 'person',
          affiliation: [
            {
              value: 'University of Zurich'
            }
          ]
        }
      )
    end
    let(:id_generator) { Cocina::Models::Mapping::ToMods::IdGenerator.new }

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
          <name type="personal">
            <namePart>Schmedders, Karl</namePart>
            <affiliation>University of Zurich</affiliation>
          </name>
        </mods>
      XML
    end
  end

  context 'when contributor affiliation includes a department' do
    let(:contributor) do
      Cocina::Models::Contributor.new(
        {
          name: [
            {
              value: 'Schmedders, Karl'
            }
          ],
          type: 'person',
          affiliation: [
            {
              structuredValue: [
                {
                  value: 'Stanford University',
                  identifier: [
                    {
                      uri: 'https://ror.org/00f54p054',
                      type: 'ROR',
                      source: {
                        code: 'ror'
                      }
                    }
                  ]
                },
                {
                  value: 'Woods Institute for the Environment'
                }
              ]
            }
          ]
        }
      )
    end
    let(:id_generator) { Cocina::Models::Mapping::ToMods::IdGenerator.new }

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
          <name type="personal">
            <namePart>Schmedders, Karl</namePart>
            <affiliation>Stanford University, Woods Institute for the Environment</affiliation>
          </name>
        </mods>
      XML
    end
  end
end
