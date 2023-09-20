# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Mapping::ToMods::Note do
  subject(:xml) { writer.to_xml }

  let(:writer) do
    Nokogiri::XML::Builder.new do |xml|
      xml.mods('xmlns' => 'http://www.loc.gov/mods/v3',
               'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
               'version' => '3.6',
               'xsi:schemaLocation' => 'http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd') do
        described_class.write(xml: xml, notes: notes, id_generator: id_generator)
      end
    end
  end
  let(:id_generator) { nil }

  context 'when notes is nil' do
    let(:notes) { nil }

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
        </mods>
      XML
    end
  end

  context 'when notes has html' do
    let(:notes) { [Cocina::Models::DescriptiveValue.new(value: 'I have some <cite>title</cite> and <i>italic</i> formats.')] }

    it 'escapes the html' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
          <note>I have some <![CDATA[<cite>]]>title<![CDATA[</cite>]]> and <![CDATA[<i>]]>italic<![CDATA[</i>]]> formats.</note>
        </mods>
      XML
    end
  end

  context 'when notes has a parallelValue' do
    let(:notes) do
      [
        Cocina::Models::DescriptiveValue.new(
          parallelValue:
            [
              Cocina::Models::DescriptiveValue.new(value: 'monthly', type: 'frequency'),
              Cocina::Models::DescriptiveValue.new(value: 'some other value')
            ]
        )
      ]
    end
    let(:id_generator) { Cocina::Models::Mapping::ToMods::IdGenerator.new }

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
          <note altRepGroup="1" type="frequency">monthly</note>
          <note altRepGroup="1">some other value</note>
        </mods>
      XML
    end
  end
end
