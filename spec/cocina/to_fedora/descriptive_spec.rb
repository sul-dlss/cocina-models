# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::ToFedora::Descriptive do
  subject(:xml) { described_class.transform(descriptive, druid).to_xml }

  context 'with a minimal description' do
    let(:druid) { 'druid:aa666bb1234' }
    let(:descriptive) do
      Cocina::Models::Description.new(
        title: [
          { value: 'Gaudy night' }
        ],
        purl: 'https://purl.stanford.edu/aa666bb1234'
      )
    end

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.7"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
          <titleInfo>
            <title>Gaudy night</title>
          </titleInfo>
          <location>
            <url usage="primary display">https://purl.stanford.edu/aa666bb1234</url>
          </location>
        </mods>
      XML
    end
  end

  context 'when it has an abstract' do
    let(:druid) { 'druid:aa666bb1234' }
    let(:descriptive) do
      Cocina::Models::Description.new(
        title: [
          { value: 'Gaudy night' }
        ],
        purl: 'https://purl.stanford.edu/aa666bb1234',
        note: [
          {
            value: 'This is an abstract.',
            type: 'abstract'
          }
        ],
        form: [
          {
            value: '1:22,000,000',
            type: 'map scale'
          },
          {
            value: 'Conic proj',
            type: 'map projection'
          }
        ],
        subject: [
          {
            value: 'E 72°--E 148°/N 13°--N 18°',
            type: 'map coordinates',
            encoding: {
              value: 'DMS'
            }
          }
        ],
        event: [
          {
            type: 'creation',
            date: [
              {
                value: '1980'
              }
            ]
          }
        ]
      )
    end

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.7"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
          <titleInfo>
            <title>Gaudy night</title>
          </titleInfo>
          <abstract>This is an abstract.</abstract>
          <subject>
            <cartographics>
              <coordinates>E 72°--E 148°/N 13°--N 18°</coordinates>
              <scale>1:22,000,000</scale>
              <projection>Conic proj</projection>
            </cartographics>
          </subject>
          <originInfo eventType="creation">
            <dateCreated>1980</dateCreated>
          </originInfo>
          <location>
            <url usage="primary display">https://purl.stanford.edu/aa666bb1234</url>
          </location>
        </mods>
      XML
    end
  end

  context 'with a MODS version specified in note' do
    let(:druid) { 'druid:aa666bb1234' }
    let(:descriptive) do
      Cocina::Models::Description.new(
        title: [
          { value: 'Gaudy night' }
        ],
        purl: 'https://purl.stanford.edu/aa666bb1234',
        adminMetadata: {
          note: [
            {
              value: 'Converted from MARCXML to MODS version 3.7 using MARC21slim2MODS3-7_SDR_v1.xsl ' \
                     '(SUL 3.7 version 1.1 20200917; LC Revision 1.140 20200717)',
              type: 'record origin'
            }
          ]
        }
      )
    end

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
         <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns="http://www.loc.gov/mods/v3" version="3.7"
           xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
           <titleInfo>
             <title>Gaudy night</title>
           </titleInfo>
           <recordInfo>
            <recordOrigin>Converted from MARCXML to MODS version 3.7 using MARC21slim2MODS3-7_SDR_v1.xsl (SUL 3.7 version 1.1 20200917; LC Revision 1.140 20200717)</recordOrigin>
          </recordInfo>
          <location>
          <url usage="primary display">https://purl.stanford.edu/aa666bb1234</url>
        </location>
         </mods>
      XML
    end
  end
end
