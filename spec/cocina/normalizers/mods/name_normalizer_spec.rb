# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Normalizers::Mods::NameNormalizer do
  let(:normalized_ng_xml) { Cocina::Normalizers::ModsNormalizer.normalize(mods_ng_xml: mods_ng_xml, druid: nil, label: nil).to_xml }

  context 'when the role term has no type' do
    let(:mods_ng_xml) do
      Nokogiri::XML <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name>
            <namePart>Dunnett, Dorothy</namePart>
            <role>
              <roleTerm>photographer</roleTerm>
            </role>
          </name>
        </mods>
      XML
    end

    it 'add type="text"' do
      expect(normalized_ng_xml).to be_equivalent_to <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name>
            <namePart>Dunnett, Dorothy</namePart>
            <role>
              <roleTerm type="text">photographer</roleTerm>
            </role>
          </name>
        </mods>
      XML
    end
  end

  context 'when the roleTerm is empty and no valueURI or URI attribute' do
    let(:mods_ng_xml) do
      Nokogiri::XML <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name type="personal" authority="local">
            <namePart>Burke, Andy</namePart>
            <role>
              <roleTerm authority="marcrelator" type="text"/>
            </role>
          </name>
        </mods>
      XML
    end

    it 'removes the roleTerm (and role, if empty)' do
      expect(normalized_ng_xml).to be_equivalent_to <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name type="personal" authority="local">
            <namePart>Burke, Andy</namePart>
          </name>
        </mods>
      XML
    end
  end

  context 'when the role has no subelement, no attributes' do
    let(:mods_ng_xml) do
      Nokogiri::XML <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name type="personal" authority="local">
            <namePart>Burke, Andy</namePart>
            <role>
            </role>
          </name>
        </mods>
      XML
    end

    it 'removes the role' do
      expect(normalized_ng_xml).to be_equivalent_to <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name type="personal" authority="local">
            <namePart>Burke, Andy</namePart>
          </name>
        </mods>
      XML
    end
  end

  context 'when normalizing empty names' do
    let(:mods_ng_xml) do
      Nokogiri::XML <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name>
            <namePart/>
            <role>
              <roleTerm authority="marcrelator" type="text">author</roleTerm>
            </role>
          </name>
        </mods>
      XML
    end

    it 'removes name' do
      expect(normalized_ng_xml).to be_equivalent_to <<~XML
        <mods #{MODS_ATTRIBUTES}>
        </mods>
      XML
    end
  end

  context 'with missing namePart element' do
    let(:mods_ng_xml) do
      Nokogiri::XML <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name>
            <role>
              <roleTerm type="code" authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators" valueURI="http://id.loc.gov/vocabulary/relators/spn">spn</roleTerm>
              <roleTerm type="text" authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators" valueURI="http://id.loc.gov/vocabulary/relators/spn">Sponsor</roleTerm>
            </role>
          </name>
        </mods>
      XML
    end

    it 'removes name' do
      expect(normalized_ng_xml).to be_equivalent_to <<~XML
        <mods #{MODS_ATTRIBUTES}>
        </mods>
      XML
    end
  end

  context 'when name has xlink:href' do
    let(:mods_ng_xml) do
      Nokogiri::XML <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name type="personal" authority="naf" xlink:href="http://id.loc.gov/authorities/names/n82087745">
            <namePart>Tirion, Isaak</namePart>
          </name>
        </mods>
      XML
    end

    it 'is converted to valueURI' do
      expect(normalized_ng_xml).to be_equivalent_to <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name type="personal" authority="naf" valueURI="http://id.loc.gov/authorities/names/n82087745">
            <namePart>Tirion, Isaak</namePart>
          </name>
        </mods>
      XML
    end
  end

  context 'when duplicate names' do
    let(:mods_ng_xml) do
      Nokogiri::XML <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name>
            <namePart>Dunnett, Dorothy</namePart>
          </name>
          <name>
            <namePart>Dunnett, Dorothy</namePart>
          </name>
          <name type="personal" usage="primary" nameTitleGroup="1">
            <namePart>Guillaume</namePart>
            <namePart type="termsOfAddress">de Lorris</namePart>
            <namePart type="date">active 1230</namePart>
          </name>
          <name type="personal">
            <namePart>Guillaume</namePart>
            <namePart type="termsOfAddress">de Lorris</namePart>
            <namePart type="date">active 1230</namePart>
          </name>
          <name type="personal">
            <namePart>Cat, Vinsky</namePart>
            <role>
              <roleTerm type="text">author</roleTerm>
            </role>
          </name>
          <name type="personal">
            <namePart>Cat, Vinsky</namePart>
            <role>
              <roleTerm type="text">editor</roleTerm>
            </role>
          </name>
          <name type="personal" nameTitleGroup="2">
            <namePart>Sheng, Bright</namePart>
            <namePart type="date">1955-</namePart>
          </name>
          <name type="personal">
            <namePart>Sheng, Bright</namePart>
            <namePart type="date">1955-</namePart>
            <role>
              <roleTerm authority="marcrelator" type="code">prf</roleTerm>
            </role>
          </name>
          <name type="personal">
            <namePart>Yeager, Helen F</namePart>
            <role>
              <roleTerm type="text">joint author</roleTerm>
            </role>
            <role>
              <roleTerm type="text">joint author</roleTerm>
            </role>
          </name>
          <name type="personal" authority="naf" authorityURI="http://id.loc.gov/authorities/names/" valueURI="http://id.loc.gov/authorities/names/no2001099549">
            <namePart>Bickley, Tom</namePart>
            <role>
              <roleTerm type="code" authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators" valueURI="http://id.loc.gov/vocabulary/relators/prf">prf</roleTerm>
              <roleTerm type="text" authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators" valueURI="http://id.loc.gov/vocabulary/relators/prf">performer</roleTerm>
            </role>
            <role>
              <roleTerm type="code" authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators" valueURI="http://id.loc.gov/vocabulary/relators/prf">prf</roleTerm>
              <roleTerm type="text" authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators" valueURI="http://id.loc.gov/vocabulary/relators/prf">performer</roleTerm>
            </role>
          </name>
          <relatedItem>
            <name>
              <namePart>Dunnett, Dorothy</namePart>
            </name>
            <name>
              <namePart>Dunnett, Dorothy</namePart>
            </name>
          </relatedItem>
        </mods>
      XML
    end

    # nameTitleGroup attribute dropped below because no match, but normally wouldn't be.
    it 'duplicates are removed' do
      expect(normalized_ng_xml).to be_equivalent_to <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name>
            <namePart>Dunnett, Dorothy</namePart>
          </name>
          <name type="personal">
            <namePart>Cat, Vinsky</namePart>
            <role>
              <roleTerm type="text">author</roleTerm>
            </role>
            <role>
              <roleTerm type="text">editor</roleTerm>
            </role>
          </name>
          <name type="personal" usage="primary">
            <namePart>Guillaume</namePart>
            <namePart type="termsOfAddress">de Lorris</namePart>
            <namePart type="date">active 1230</namePart>
          </name>
          <name type="personal">
            <namePart>Sheng, Bright</namePart>
            <namePart type="date">1955-</namePart>
            <role>
              <roleTerm authority="marcrelator" type="code">prf</roleTerm>
            </role>
          </name>
          <name type="personal">
            <namePart>Yeager, Helen F</namePart>
            <role>
              <roleTerm type="text">joint author</roleTerm>
            </role>
          </name>
          <name type="personal" authority="naf" authorityURI="http://id.loc.gov/authorities/names/" valueURI="http://id.loc.gov/authorities/names/no2001099549">
            <namePart>Bickley, Tom</namePart>
            <role>
              <roleTerm type="code" authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators/" valueURI="http://id.loc.gov/vocabulary/relators/prf">prf</roleTerm>
              <roleTerm type="text" authority="marcrelator" authorityURI="http://id.loc.gov/vocabulary/relators/" valueURI="http://id.loc.gov/vocabulary/relators/prf">performer</roleTerm>
            </role>
          </name>
          <relatedItem>
            <name>
              <namePart>Dunnett, Dorothy</namePart>
            </name>
          </relatedItem>
        </mods>
      XML
    end
  end

  context 'when name@type value incorrectly capitalized' do
    let(:mods_ng_xml) do
      Nokogiri::XML <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name type="Personal" usage="primary">
            <namePart>Dunnett, Dorothy</namePart>
          </name>
        </mods>
      XML
    end

    it 'corrects value to lower case' do
      expect(normalized_ng_xml).to be_equivalent_to <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name type="personal" usage="primary">
            <namePart>Dunnett, Dorothy</namePart>
          </name>
        </mods>
      XML
    end
  end

  context 'when name@type not recognized' do
    let(:mods_ng_xml) do
      Nokogiri::XML <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name type="fred">
            <namePart>Dunnett, Dorothy</namePart>
          </name>
        </mods>
      XML
    end

    it 'removes type attribute' do
      expect(normalized_ng_xml).to be_equivalent_to <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name>
            <namePart>Dunnett, Dorothy</namePart>
          </name>
        </mods>
      XML
    end
  end

  context 'when namePart has a invalid type attribute' do
    let(:mods_ng_xml) do
      Nokogiri::XML <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name>
            <namePart type="personal">Dunnett, Dorothy</namePart>
          </name>
        </mods>
      XML
    end

    it 'removes invalid type attribute' do
      expect(normalized_ng_xml).to be_equivalent_to <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name>
            <namePart>Dunnett, Dorothy</namePart>
          </name>
        </mods>
      XML
    end
  end

  context 'when multilingual names with roles' do
    let(:mods_ng_xml) do
      Nokogiri::XML <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name type="personal" altRepGroup="05">
            <namePart>Haran, Menahem</namePart>
            <role>
              <roleTerm type="text">ed</roleTerm>
            </role>
          </name>
          <name type="personal" altRepGroup="05">
            <namePart>&#x5D4;&#x5E8;&#x5DF;, &#x5DE;&#x5E0;&#x5D7;&#x5DD;</namePart>
          </name>
        </mods>
      XML
    end

    it 'adds roles to all names' do
      expect(normalized_ng_xml).to be_equivalent_to <<~XML
        <mods #{MODS_ATTRIBUTES}>
          <name type="personal" altRepGroup="05">
            <namePart>Haran, Menahem</namePart>
            <role>
              <roleTerm type="text">ed</roleTerm>
            </role>
          </name>
          <name type="personal" altRepGroup="05">
            <namePart>&#x5D4;&#x5E8;&#x5DF;, &#x5DE;&#x5E0;&#x5D7;&#x5DD;</namePart>
            <role>
              <roleTerm type="text">ed</roleTerm>
            </role>
          </name>
        </mods>
      XML
    end
  end
end
