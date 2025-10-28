# frozen_string_literal: true

MODS_ATTRIBUTES = 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" version="3.7"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd"'

def add_purl_and_title(cocina, druid)
  cocina.merge({
    purl: cocina.fetch(:purl, Cocina::Models::Mapping::Purl.for(druid: druid)),
    title: cocina.key?(:title) ? nil : [{ value: label }]
  }.compact)
end

RSpec.shared_examples 'cocina to MODS' do |expected_xml|
  subject(:xml) { writer.to_xml }

  # writer object is declared in the context of calling examples

  let(:mods_attributes) do
    {
      'xmlns' => 'http://www.loc.gov/mods/v3',
      'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
      'version' => '3.6',
      'xsi:schemaLocation' => 'http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd'
    }
  end

  it 'builds the expected xml' do
    expect(xml).to be_equivalent_to <<~XML
      <mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://www.loc.gov/mods/v3" version="3.6"
        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd">
        #{expected_xml}
      </mods>
    XML
  end
end

# When starting from MODS.
RSpec.shared_examples 'MODS cocina mapping' do
  # Required: mods, cocina
  # Optional: druid, roundtrip_mods, warnings, errors, mods_attributes, skip_normalization, label

  let(:orig_cocina_description) { Cocina::Models::Description.new(add_purl_and_title(cocina, local_druid)) }

  let(:orig_mods_ng) { ng_mods_for(mods, mods_attributes) }

  let(:mods_attributes) { MODS_ATTRIBUTES }

  let(:roundtrip_mods_ng) { defined?(roundtrip_mods) ? ng_mods_for(roundtrip_mods, MODS_ATTRIBUTES) : nil }

  let(:local_druid) { defined?(druid) ? druid : 'druid:zn746hz1696' }

  let(:local_warnings) { defined?(warnings) ? warnings : [] }

  let(:local_errors) { defined?(errors) ? errors : [] }

  let(:skip_normalization) { false }

  let(:label) { 'Test title' }

  context 'when mapping from MODS (to cocina)' do
    let(:notifier) { instance_double(Cocina::Models::Mapping::ErrorNotifier) }

    let(:actual_cocina_props) do
      Cocina::Models::Mapping::FromMods::Description.props(mods: orig_mods_ng, druid: local_druid, notifier: notifier, label: label)
    end

    before do
      allow(notifier).to receive(:warn)
      allow(notifier).to receive(:error)
    end

    it 'mods snippet(s) produce valid MODS' do
      expect { orig_mods_ng }.not_to raise_error
      expect { roundtrip_mods_ng }.not_to raise_error
    end

    it 'cocina hash produces valid cocina Description' do
      cocina_props = actual_cocina_props.deep_dup
      expect { Cocina::Models::Description.new(cocina_props) }.not_to raise_error
    end

    it 'MODS maps to expected cocina' do
      expect(actual_cocina_props).to be_deep_equal(add_purl_and_title(cocina, local_druid))
    end

    it 'notifier receives warning and/or error messages as specified' do
      # TODO: support testing with no title
      Cocina::Models::Mapping::FromMods::Description.props(mods: orig_mods_ng, druid: local_druid, notifier: notifier, title_builder: TestTitleBuilder,
                                                           label: label)
      if local_warnings.empty?
        expect(notifier).not_to have_received(:warn)
      else
        local_warnings.each do |warning|
          if warning.context
            expect(notifier).to have_received(:warn).with(warning.msg, warning.context).exactly(warning.times || 1).times
          else
            expect(notifier).to have_received(:warn).with(warning.msg).exactly(warning.times || 1).times
          end
        end
      end

      if local_errors.empty?
        expect(notifier).not_to have_received(:error)
      else
        local_errors.each do |error|
          if error.context
            expect(notifier).to have_received(:error).with(error.msg, error.context).exactly(error.times || 1).times
          else
            expect(notifier).to have_received(:error).with(error.msg).exactly(error.times || 1).times
          end
        end
      end
    end
  end

  context 'when mapping to MODS (from cocina)' do
    let(:expected_mods_ng) do
      Cocina::Models::Mapping::Normalizers::ModsNormalizer.normalize_purl_and_missing_title(mods_ng_xml: roundtrip_mods_ng || orig_mods_ng, druid: local_druid,
                                                                                            label: label)
    end

    let(:actual_mods_ng) { Cocina::Models::Mapping::ToMods::Description.transform(orig_cocina_description, local_druid) }

    let(:actual_xml) { actual_mods_ng.to_xml }

    it 'cocina Description maps to expected MODS' do
      expect(actual_xml).to be_equivalent_to expected_mods_ng.to_xml
    end

    it 'cocina Description maps to normalized MODS' do
      # the starting MODS is normalized to address discrepancies found against MODS roundtripped to data store (Fedora)
      #  and back, per Arcadia's specifications.  E.g., removal of empty nodes and attributes; addition of eventType to
      #  originInfo nodes.
      unless skip_normalization
        expect(actual_xml).to be_equivalent_to Cocina::Models::Mapping::Normalizers::ModsNormalizer.normalize(mods_ng_xml: orig_mods_ng, druid: local_druid,
                                                                                                              label: label).to_xml
      end
    end
  end

  context 'when mapping from roundtrip MODS (to cocina)' do
    let(:notifier) { instance_double(Cocina::Models::Mapping::ErrorNotifier) }

    let(:roundtrip_mods_xml) do
      if defined?(roundtrip_mods)
        Cocina::Models::Mapping::Normalizers::ModsNormalizer.normalize_purl_and_missing_title(mods_ng_xml: roundtrip_mods_ng, druid: local_druid,
                                                                                              label: label).to_xml
      end
    end

    let(:roundtrip_cocina_props) do
      Cocina::Models::Mapping::FromMods::Description.props(mods: roundtrip_mods_ng, druid: local_druid, notifier: notifier, label: label)
    end

    let(:roundtrip_cocina_description) { Cocina::Models::Description.new(roundtrip_cocina_props) }

    let(:re_roundtrip_mods_xml) { Cocina::Models::Mapping::ToMods::Description.transform(roundtrip_cocina_description, local_druid).to_xml }

    before do
      allow(notifier).to receive(:warn)
      allow(notifier).to receive(:error)
    end

    it 'roundtrip MODS maps to expected cocina' do
      expect(roundtrip_cocina_props).to be_deep_equal(add_purl_and_title(cocina, local_druid)) if defined?(roundtrip_mods)
    end

    it 'roundtrip cocina maps to roundtrip MODS' do
      expect(re_roundtrip_mods_xml).to be_equivalent_to roundtrip_mods_xml if defined?(roundtrip_mods)
    end

    it 'roundtrip cocina maps to normalized roundtrip MODS' do
      # the starting MODS is normalized to address discrepancies found against MODS roundtripped to data store (Fedora)
      #  and back, per Arcadia's specifications.  E.g., removal of empty nodes and attributes; addition of eventType to
      #  originInfo nodes.
      if defined?(roundtrip_mods)
        normalized_rt_mods_xml = Cocina::Models::Mapping::Normalizers::ModsNormalizer.normalize(mods_ng_xml: Nokogiri::XML(roundtrip_mods_xml), druid: local_druid,
                                                                                                label: label).to_xml
      end
      expect(re_roundtrip_mods_xml).to be_equivalent_to normalized_rt_mods_xml if defined?(roundtrip_mods)
    end
  end
end

# When starting from cocina, e.g., H3 and roundtrips.
RSpec.shared_examples 'cocina MODS mapping' do
  # Required: mods, cocina
  # Optional: druid, roundtrip_cocina, warnings, errors, mods_attributes, label

  let(:orig_cocina_description) { Cocina::Models::Description.new(add_purl_and_title(cocina, local_druid)) }

  let(:mods_attributes) { MODS_ATTRIBUTES }

  let(:mods_ng) { ng_mods_for(mods, mods_attributes) }

  let(:mods_xml) { mods_ng.to_xml }

  let(:local_druid) { defined?(druid) ? druid : 'druid:zn746hz1696' }

  let(:local_warnings) { defined?(warnings) ? warnings : [] }

  let(:local_errors) { defined?(errors) ? errors : [] }

  let(:label) { 'Test title' }

  context 'when mapping from cocina (to MODS)' do
    let(:actual_mods_ng) { Cocina::Models::Mapping::ToMods::Description.transform(orig_cocina_description, local_druid) }

    let(:actual_xml) { actual_mods_ng.to_xml }

    it 'mods snippet(s) produce valid MODS' do
      expect { mods_ng }.not_to raise_error
    end

    # as we are starting with a cocina representation, there may be empty cocina values
    # which could result in empty MODS elements from the transform.  The empty elements are correct at this point.
    it 'cocina Description maps to expected MODS' do
      expect(actual_xml).to be_equivalent_to Cocina::Models::Mapping::Normalizers::ModsNormalizer.normalize_purl_and_missing_title(mods_ng_xml: mods_ng, druid: local_druid,
                                                                                                                                   label: label).to_xml
    end
  end

  context 'when mapping to cocina (from MODS)' do
    let(:notifier) { instance_double(Cocina::Models::Mapping::ErrorNotifier) }

    let(:actual_cocina_props) { Cocina::Models::Mapping::FromMods::Description.props(mods: mods_ng, druid: local_druid, notifier: notifier, label: label) }

    let(:expected_cocina) { defined?(roundtrip_cocina) ? roundtrip_cocina : cocina }

    before do
      allow(notifier).to receive(:warn)
      allow(notifier).to receive(:error)
    end

    it 'cocina hash produces valid cocina Description' do
      cocina_props = actual_cocina_props.deep_dup
      cocina_props[:title] = [{ value: 'Test title' }] if cocina_props[:title].nil?
      expect { Cocina::Models::Description.new(cocina_props) }.not_to raise_error
    end

    it 'MODS maps to expected cocina' do
      expect(actual_cocina_props).to eq(add_purl_and_title(expected_cocina, local_druid))
    end

    it 'notifier receives warning and/or error messages as specified' do
      Cocina::Models::Mapping::FromMods::Description.props(mods: mods_ng, druid: local_druid, notifier: notifier, title_builder: TestTitleBuilder,
                                                           label: label)
      if local_warnings.empty?
        expect(notifier).not_to have_received(:warn)
      else
        local_warnings.each do |warning|
          if warning.context
            expect(notifier).to have_received(:warn).with(warning.msg, warning.context).exactly(warning.times || 1).times
          else
            expect(notifier).to have_received(:warn).with(warning.msg).exactly(warning.times || 1).times
          end
        end
      end

      if local_errors.empty?
        expect(notifier).not_to have_received(:error)
      else
        local_errors.each do |error|
          if error.context
            expect(notifier).to have_received(:error).with(error.msg, error.context).exactly(error.times || 1).times
          else
            expect(notifier).to have_received(:error).with(error.msg).exactly(error.times || 1).times
          end
        end
      end
    end
  end

  context 'when mapping from roundtrip cocina (to MODS)' do
    let(:notifier) { instance_double(Cocina::Models::Mapping::ErrorNotifier) }

    let(:my_roundtrip_cocina) { defined?(roundtrip_cocina) ? roundtrip_cocina : cocina }

    let(:roundtrip_cocina_description) { Cocina::Models::Description.new(add_purl_and_title(my_roundtrip_cocina, local_druid), false, false) }

    let(:roundtrip_mods_ng) { Cocina::Models::Mapping::ToMods::Description.transform(roundtrip_cocina_description, local_druid) }

    let(:roundtrip_mods_xml) { roundtrip_mods_ng.to_xml }

    let(:re_roundtrip_cocina_props) do
      Cocina::Models::Mapping::FromMods::Description.props(mods: roundtrip_mods_ng, druid: local_druid, notifier: notifier, label: label)
    end

    before do
      allow(notifier).to receive(:warn)
      allow(notifier).to receive(:error)
    end

    it 'roundtrip cocina Description maps to expected MODS, normalized' do
      # the roundtrip cocina is, effectively, the cocina for the normalized MODS - the MODS is normalized before it gets to cocina
      if defined?(roundtrip_cocina)
        normalized_mods_xml = Cocina::Models::Mapping::Normalizers::ModsNormalizer.normalize(mods_ng_xml: Nokogiri::XML(mods_xml), druid: local_druid,
                                                                                             label: label).to_xml
      end
      expect(roundtrip_mods_xml).to be_equivalent_to normalized_mods_xml if defined?(roundtrip_cocina)
    end

    it 'roundtrip MODS maps to roundtrip cocina' do
      expect(re_roundtrip_cocina_props).to eq(add_purl_and_title(roundtrip_cocina, local_druid)) if defined?(roundtrip_cocina)
    end
  end
end

# When starting from cocina, e.g., H3 and does not (intentionally) roundtrip.
RSpec.shared_examples 'cocina to MODS only mapping' do
  # Required: mods, cocina
  # Optional: druid, label

  let(:orig_cocina_description) { Cocina::Models::Description.new(add_purl_and_title(cocina, local_druid)) }

  let(:mods_attributes) { MODS_ATTRIBUTES }

  let(:mods_ng) { ng_mods_for(mods, mods_attributes) }

  let(:local_druid) { defined?(druid) ? druid : 'druid:zn746hz1696' }

  let(:label) { 'Test title' }

  context 'when mapping from cocina (to MODS)' do
    let(:actual_mods_ng) { Cocina::Models::Mapping::ToMods::Description.transform(orig_cocina_description, local_druid) }

    let(:actual_xml) { actual_mods_ng.to_xml }

    it 'mods snippet(s) produce valid MODS' do
      expect { mods_ng }.not_to raise_error
    end

    # as we are starting with a cocina representation, there may be empty cocina values
    # which could result in empty MODS elements from the transform.  The empty elements are correct at this point.
    it 'cocina Description maps to expected MODS' do
      expect(actual_xml).to be_equivalent_to Cocina::Models::Mapping::Normalizers::ModsNormalizer.normalize_purl_and_missing_title(mods_ng_xml: mods_ng, druid: local_druid,
                                                                                                                                   label: label).to_xml
    end
  end
end

def ng_mods_for(snippet, mods_attributes)
  xml = <<~XML
    <mods #{mods_attributes}>
      #{snippet}
    </mods>
  XML
  Nokogiri.XML(xml, nil, 'UTF-8', Nokogiri::XML::ParseOptions.new.strict)
end

Notification = Struct.new(:msg, :context, :times, keyword_init: true)

# Builds titles for tests
class TestTitleBuilder
  # @param [Nokogiri::XML::Element] resource_element mods or relatedItem element
  # @param [Cocina::Models::Mapping::ErrorNotifier] notifier
  # @return [Hash] a hash that can be mapped to a cocina model
  def self.build(resource_element:, notifier:, require_title:)
    titles = resource_element.xpath('mods:titleInfo', mods: Cocina::Models::Mapping::FromMods::Description::DESC_METADATA_NS)
    if titles.empty?
      [{ value: 'Placeholder title for specs' }]
    else
      Cocina::Models::Mapping::FromMods::Title.build(resource_element: resource_element, notifier: notifier, require_title: require_title)
    end
  end
end
