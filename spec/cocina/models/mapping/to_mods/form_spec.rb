# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Mapping::ToMods::Form do
  subject(:xml) { writer.to_xml }

  let(:writer) do
    Nokogiri::XML::Builder.new do |xml|
      xml.mods('xmlns' => 'http://www.loc.gov/mods/v3',
               'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
               'version' => '3.6',
               'xsi:schemaLocation' => 'http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd') do
        described_class.write(xml: xml, forms: forms, id_generator: nil)
      end
    end
  end

  context 'when form is nil' do
    let(:forms) { nil }

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
        </mods>
      XML
    end
  end

  context 'with typical self-deposit forms (i.e., with datacite metadata)' do
    let(:forms) do
      [
        Cocina::Models::DescriptiveValue.new(
          structuredValue: [
            Cocina::Models::DescriptiveValue.new(
              value: 'Image',
              type: 'type'
            )
          ],
          type: 'resource type',
          source: Cocina::Models::Source.new(value: 'Stanford self-deposit resource types')
        ),
        Cocina::Models::DescriptiveValue.new(
          value: 'still image',
          type: 'resource type',
          source: Cocina::Models::Source.new(value: 'MODS resource types')
        ),
        Cocina::Models::DescriptiveValue.new(
          value: 'Image',
          type: 'resource type',
          source: Cocina::Models::Source.new(value: 'DataCite resource types')
        )
      ]
    end

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
         <genre type="Self deposit type">Image</genre>
         <typeOfResource>still image</typeOfResource>
         <extension displayLabel="datacite">
           <resourceType resourceTypeGeneral="Image">Image</resourceType>
         </extension>
        </mods>
      XML
    end
  end

  context 'with typical ETD forms (i.e., with datacite metadata)' do
    let(:forms) do
      [
        Cocina::Models::DescriptiveValue.new(
          value: 'text',
          type: 'resource type',
          source: Cocina::Models::Source.new(value: 'MODS resource types')
        ),
        Cocina::Models::DescriptiveValue.new(
          value: 'theses',
          type: 'genre',
          source: Cocina::Models::Source.new(code: 'marcgt')
        ),
        Cocina::Models::DescriptiveValue.new(
          value: 'electronic resource',
          type: 'form',
          source: Cocina::Models::Source.new(code: 'marccategory')
        ),
        Cocina::Models::DescriptiveValue.new(
          value: 'computer',
          type: 'media',
          source: Cocina::Models::Source.new(code: 'rdamedia')
        ),
        Cocina::Models::DescriptiveValue.new(
          value: 'online resource',
          type: 'carrier',
          source: Cocina::Models::Source.new(code: 'rdacarrier')
        ),
        Cocina::Models::DescriptiveValue.new(
          value: '1 online resource',
          type: 'extent'
        ),
        Cocina::Models::DescriptiveValue.new(
          structuredValue: [
            Cocina::Models::DescriptiveValue.new(
              value: 'Academic thesis',
              type: 'type'
            )
          ],
          type: 'resource type',
          source: Cocina::Models::Source.new(value: 'Stanford self-deposit resource types')
        ),
        Cocina::Models::DescriptiveValue.new(
          value: 'Dissertation',
          type: 'resource type',
          source: Cocina::Models::Source.new(value: 'DataCite resource types')
        )
      ]
    end

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
          <genre type="Self deposit type">Academic thesis</genre>
          <extension displayLabel="datacite">
            <resourceType resourceTypeGeneral="Dissertation">Academic thesis</resourceType>
          </extension>
          <typeOfResource>text</typeOfResource>
          <genre authority="marcgt">theses</genre>
          <physicalDescription>
            <form authority="marccategory">electronic resource</form>
            <form type="media" authority="rdamedia">computer</form>
            <form type="carrier" authority="rdacarrier">online resource</form>
            <extent>1 online resource</extent>
          </physicalDescription>
        </mods>
      XML
    end
  end
end
