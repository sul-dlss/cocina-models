# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Mapping::ToMods::RelatedResource do
  subject(:xml) { writer.to_xml }

  let(:writer) do
    Nokogiri::XML::Builder.new do |xml|
      xml.mods('xmlns' => 'http://www.loc.gov/mods/v3',
               'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
               'version' => '3.6',
               'xsi:schemaLocation' => 'http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd') do
        described_class.write(xml: xml, related_resources: resources, druid: 'druid:vx162kw9911',
                              id_generator: Cocina::Models::Mapping::ToMods::IdGenerator.new)
      end
    end
  end

  context 'when relatedResource is nil' do
    let(:resources) { nil }

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
        </mods>
      XML
    end
  end

  context 'when it has a related item with the generic "related to" type (related link from H2)' do
    let(:resources) do
      [
        Cocina::Models::RelatedResource.new(
          title: [
            {
              value: 'Supplement'
            }
          ],
          access: {
            url: [
              value: 'https://example.com/paper.html'
            ]
          },
          type: 'related to'
        )
      ]
    end

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
          <relatedItem>
            <titleInfo>
              <title>Supplement</title>
            </titleInfo>
            <location>
              <url>https://example.com/paper.html</url>
            </location>
          </relatedItem>
        </mods>
      XML
    end
  end

  context 'when it has a related item with the generic "related to" type (related work from H2)' do
    let(:resources) do
      [
        Cocina::Models::RelatedResource.new(
          note: [
            {
              value: 'Stanford University (Stanford, CA.). (2020)',
              type: 'preferred citation'
            }
          ],
          type: 'related to'
        )
      ]
    end

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
          <relatedItem>
            <note type="preferred citation">Stanford University (Stanford, CA.). (2020)</note>
          </relatedItem>
        </mods>
      XML
    end
  end

  context 'when it has multiple related items' do
    let(:resources) do
      [
        Cocina::Models::RelatedResource.new(
          title: [
            {
              value: 'Related item 1'
            }
          ]
        ),
        Cocina::Models::RelatedResource.new(
          title: [
            {
              value: 'Related item 2'
            }
          ]
        )
      ]
    end

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
          <relatedItem>
            <titleInfo>
              <title>Related item 1</title>
            </titleInfo>
          </relatedItem>
          <relatedItem>
            <titleInfo>
              <title>Related item 2</title>
            </titleInfo>
          </relatedItem>
        </mods>
      XML
    end
  end

  context 'when it has displayLabel' do
    let(:resources) do
      [
        Cocina::Models::RelatedResource.new(
          title: [
            {
              value: 'Fremontia : Journal of the California Native Plant Society'
            }
          ],
          displayLabel: 'Contained in (manifestation):'
        )
      ]
    end

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
          <relatedItem displayLabel="Contained in (manifestation):">
            <titleInfo>
              <title>Fremontia : Journal of the California Native Plant Society</title>
            </titleInfo>
          </relatedItem>
        </mods>
      XML
    end
  end

  context 'when it has a related item with a contributor without a type' do
    let(:resources) do
      [
        Cocina::Models::RelatedResource.new(
          {
            title: [
              {
                value: 'Lymond chronicles'
              }
            ],
            contributor: [
              {
                name: [
                  {
                    value: 'Dunnett, Dorothy'
                  }
                ]
              }
            ]
          }
        )
      ]
    end

    it 'builds the xml' do
      expect(xml).to be_equivalent_to <<~XML
        <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns="http://www.loc.gov/mods/v3" version="3.6"
          xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
          <relatedItem>
            <titleInfo>
              <title>Lymond chronicles</title>
            </titleInfo>
            <name>
              <namePart>Dunnett, Dorothy</namePart>
            </name>
          </relatedItem>
        </mods>
      XML
    end
  end
end
