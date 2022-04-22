# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::FromFedora::Descriptive::Titles do
  describe '.build' do
    subject(:build) do
      described_class.build(resource_element: ng_xml.root, require_title: require_title, notifier: notifier)
    end

    let(:notifier) { instance_double(Cocina::FromFedora::ErrorNotifier) }

    let(:require_title) { true }

    context 'when the object has no title' do
      let(:ng_xml) do
        Nokogiri::XML(
          <<~XML
            <?xml version="1.0"?>
            <mods xmlns="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.6" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
              <titleInfo>
                <title/>
              </titleInfo>
            </mods>
          XML
        )
      end

      before do
        allow(notifier).to receive(:error)
        allow(notifier).to receive(:warn)
      end

      it 'returns empty and notifies error' do
        expect(build).to be_empty
        expect(notifier).to have_received(:error).with('Missing title')
      end
    end

    context 'when the title is empty' do
      let(:ng_xml) do
        Nokogiri::XML <<~XML
          <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://www.loc.gov/mods/v3" version="3.6"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
            <titleInfo>
              <title />
            </titleInfo>
          </mods>
        XML
      end

      before do
        allow(notifier).to receive(:error)
        allow(notifier).to receive(:warn)
      end

      it 'returns empty and notifies error' do
        expect(build).to be_empty
        expect(notifier).to have_received(:error).with('Missing title')
      end
    end

    context 'when the object has no title and not required' do
      let(:ng_xml) do
        Nokogiri::XML(
          <<~XML
            <?xml version="1.0"?>
            <mods xmlns="http://www.loc.gov/mods/v3" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="3.6" xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
              <titleInfo>
                <title/>
              </titleInfo>
            </mods>
          XML
        )
      end
      let(:require_title) { false }

      before do
        allow(notifier).to receive(:warn)
      end

      it 'returns empty and warns' do
        expect(build).to be_empty
        expect(notifier).to have_received(:warn).with('Empty title node')
      end
    end

    context 'when there are empty titles' do
      let(:ng_xml) do
        Nokogiri::XML <<~XML
          <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://www.loc.gov/mods/v3" version="3.6"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
            <titleInfo usage="primary">
              <title>Five red herrings</title>
            </titleInfo>
            <titleInfo>
              <title />
            </titleInfo>
            <titleInfo type="alternative">
              <title />
            </titleInfo>
            <titleInfo type="alternative" displayLabel="Also known as: The Usual Suspects">
              <title />
            </titleInfo>
          </mods>
        XML
      end

      before do
        allow(notifier).to receive(:warn)
      end

      it 'parses' do
        expect do
          Cocina::Models::Description.new(title: build, purl: 'https://purl.stanford.edu/aa666bb1234')
        end.not_to raise_error
      end

      it 'ignores and warns' do
        expect(build).to eq [
          { status: 'primary', value: 'Five red herrings' }
        ]
        expect(notifier).to have_received(:warn).at_least(:once).with('Empty title node')
      end
    end

    context 'when there are title types' do
      let(:ng_xml) do
        Nokogiri::XML <<~XML
          <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://www.loc.gov/mods/v3" version="3.6"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
            <titleInfo>
              <title type="main">Monaco Grand Prix</title>
            </titleInfo>
          </mods>
        XML
      end

      before do
        allow(notifier).to receive(:warn)
      end

      it 'parses' do
        expect do
          Cocina::Models::Description.new(title: build, purl: 'https://purl.stanford.edu/aa666bb1234')
        end.not_to raise_error
      end

      it 'ignores and warns' do
        expect(build).to eq [
          { value: 'Monaco Grand Prix' }
        ]
        expect(notifier).to have_received(:warn).at_least(:once).with('Title with type')
      end
    end

    context 'when there is a title with script but no lang' do
      let(:ng_xml) do
        Nokogiri::XML <<~XML
          <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://www.loc.gov/mods/v3" version="3.6"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
            <titleInfo script="Cyrl">
              <title>Война и миръ</title>
            </titleInfo>
          </mods>
        XML
      end

      it 'parses' do
        expect do
          Cocina::Models::Description.new(title: build, purl: 'https://purl.stanford.edu/aa666bb1234')
        end.not_to raise_error
      end

      it 'creates model' do
        expect(build).to eq [
          {
            value: 'Война и миръ',
            valueLanguage: {
              valueScript: {
                code: 'Cyrl',
                source: {
                  code: 'iso15924'
                }
              }
            }
          }
        ]
      end
    end

    context 'when there is a title with empty script' do
      let(:ng_xml) do
        Nokogiri::XML <<~XML
          <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://www.loc.gov/mods/v3" version="3.6"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
            <titleInfo script="">
              <title>Война и миръ</title>
            </titleInfo>
          </mods>
        XML
      end

      it 'parses' do
        expect do
          Cocina::Models::Description.new(title: build, purl: 'https://purl.stanford.edu/aa666bb1234')
        end.not_to raise_error
      end

      it 'creates model' do
        expect(build).to eq [
          {
            value: 'Война и миръ'
          }
        ]
      end
    end

    # Example 21 from mods_to_cocina_titleInfo.txt
    context 'when there is a complex multilingual title' do
      let(:ng_xml) do
        Nokogiri::XML <<~XML
          <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://www.loc.gov/mods/v3" version="3.6"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
            <titleInfo type="uniform" nameTitleGroup="1" altRepGroup="01">
              <title>Shaʻare ha-ḳedushah</title>
            </titleInfo>
            <name type="personal" usage="primary" nameTitleGroup="1">
              <namePart>Vital, Ḥayyim ben Joseph</namePart>
              <namePart type="date">1542 or 1543-1620</namePart>
            </name>
            <titleInfo altRepGroup="02">
              <title>Sefer Shaʻare ha-ḳedushah in Hebrew</title>
              <subTitle>zeh sefer le-yosher ha-adam la-ʻavodat borʼo in Hebrew</subTitle>
            </titleInfo>
            <titleInfo altRepGroup="02">
              <title>Sefer Shaʻare ha-ḳedushah</title>
              <subTitle>zeh sefer le-yosher ha-adam la-ʻavodat borʼo</subTitle>
            </titleInfo>
          </mods>
        XML
      end

      it 'raises' do
        # Raises since no associated contributor for nameTitleGroup
        expect do
          Cocina::Models::Description.new(title: build,
                                          purl: 'https://purl.stanford.edu/aa666bb1234')
        end.to raise_error(Cocina::Models::ValidationError)
      end

      it 'creates value from the authority record' do
        expect(build).to eq [
          {
            parallelValue: [
              {
                structuredValue: [
                  {
                    value: 'Sefer Shaʻare ha-ḳedushah in Hebrew',
                    type: 'main title'
                  },
                  {
                    value: 'zeh sefer le-yosher ha-adam la-ʻavodat borʼo in Hebrew',
                    type: 'subtitle'
                  }
                ]
              },
              {
                structuredValue: [
                  {
                    value: 'Sefer Shaʻare ha-ḳedushah',
                    type: 'main title'
                  },
                  {
                    value: 'zeh sefer le-yosher ha-adam la-ʻavodat borʼo',
                    type: 'subtitle'
                  }
                ]
              }
            ]
          },
          {
            value: 'Shaʻare ha-ḳedushah',
            type: 'uniform',
            note: [
              {
                type: 'associated name',
                structuredValue: [
                  {
                    value: 'Vital, Ḥayyim ben Joseph',
                    type: 'name'
                  },
                  {
                    value: '1542 or 1543-1620',
                    type: 'life dates'
                  }
                ]
              }
            ]
          }
        ]
      end
    end

    context 'when there are uniform titles with multiple name part elements (some unlabeled)' do
      let(:ng_xml) do
        Nokogiri::XML <<~XML
          <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://www.loc.gov/mods/v3" version="3.6"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
            <titleInfo type="uniform" nameTitleGroup="1">
              <title>Tractatus de intellectus emendatione. German</title>
            </titleInfo>
            <name type="personal" usage="primary" nameTitleGroup="1">
              <namePart>Spinoza, Benedictus de</namePart>
              <namePart type="date">1632-1677</namePart>
            </name>
          </mods>
        XML
      end

      it 'raises' do
        # Raises since no associated contributor for nameTitleGroup
        expect do
          Cocina::Models::Description.new(title: build,
                                          purl: 'https://purl.stanford.edu/aa666bb1234')
        end.to raise_error(Cocina::Models::ValidationError)
      end

      it 'creates value from the authority record' do
        expect(build).to eq [
          {
            value: 'Tractatus de intellectus emendatione. German',
            type: 'uniform',
            note: [
              {
                type: 'associated name',
                structuredValue: [
                  {
                    value: 'Spinoza, Benedictus de',
                    type: 'name'
                  },
                  {
                    value: '1632-1677',
                    type: 'life dates'
                  }
                ]
              }
            ]
          }
        ]
      end
    end

    context 'when there is a missing nameTitleGroup' do
      let(:ng_xml) do
        Nokogiri::XML <<~XML
          <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://www.loc.gov/mods/v3" version="3.6"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
            <titleInfo type="uniform" authority="naf" authorityURI="http://id.loc.gov/authorities/names/" valueURI="http://id.loc.gov/authorities/names/n80008522" nameTitleGroup="0">
              <title>Hamlet</title>
            </titleInfo>
          </mods>
        XML
      end

      before do
        allow(notifier).to receive(:warn)
      end

      it 'parses' do
        expect do
          Cocina::Models::Description.new(title: build, purl: 'https://purl.stanford.edu/aa666bb1234')
        end.not_to raise_error
      end

      it 'creates value from the authority record and warns' do
        expect(build).to eq [
          {
            value: 'Hamlet',
            type: 'uniform',
            uri: 'http://id.loc.gov/authorities/names/n80008522',
            source: {
              code: 'naf',
              uri: 'http://id.loc.gov/authorities/names/'
            }
          }
        ]
        expect(notifier).to have_received(:warn).at_least(:once).with("For title 'Hamlet', no name matching nameTitleGroup 0.")
      end
    end

    context 'when there are abbreviated titles without authority' do
      let(:ng_xml) do
        Nokogiri::XML <<~XML
          <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://www.loc.gov/mods/v3" version="3.6"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
            <titleInfo usage="primary">
              <title>Annual report of notifiable diseases</title>
            </titleInfo>
            <titleInfo type="abbreviated">
              <title>Annu. rep. notif. dis.</title>
            </titleInfo>
          </mods>
        XML
      end

      it 'parses' do
        expect do
          Cocina::Models::Description.new(title: build, purl: 'https://purl.stanford.edu/aa666bb1234')
        end.not_to raise_error
      end

      it 'creates simple values' do
        expect(build).to eq [
          {
            value: 'Annual report of notifiable diseases',
            status: 'primary'
          },
          {
            value: 'Annu. rep. notif. dis.',
            type: 'abbreviated'
          }
        ]
      end
    end

    context 'when there are uniform titles with empty titleInfo' do
      # From catkey:13876236
      let(:ng_xml) do
        Nokogiri::XML <<~XML
          <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns="http://www.loc.gov/mods/v3" version="3.6"
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
            <titleInfo usage="primary">
              <title>[Ritter Pázmán sketches]</title>
            </titleInfo>
            <titleInfo type="uniform" nameTitleGroup="1">
              <title/>
            </titleInfo>
            <name type="personal" usage="primary" nameTitleGroup="1">
              <namePart>Strauss, Johann</namePart>
              <namePart type="date">1825-1899</namePart>
            </name>
          </mods>
        XML
      end

      before do
        allow(notifier).to receive(:warn)
      end

      it 'parses' do
        expect do
          Cocina::Models::Description.new(title: build, purl: 'https://purl.stanford.edu/aa666bb1234')
        end.not_to raise_error
      end

      it 'skips empty titleInfo and warns' do
        expect(build).to eq [
          {
            value: '[Ritter Pázmán sketches]',
            status: 'primary'
          }
        ]
        expect(notifier).to have_received(:warn).at_least(:once).with('Empty title node')
      end
    end
  end
end
