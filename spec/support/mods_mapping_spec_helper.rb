# frozen_string_literal: true

MODS_ATTRIBUTES = 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" version="3.7"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd"'

def add_purl_and_title(cocina, druid)
  cocina.merge({
    purl: cocina.fetch(:purl, Cocina::Models::Mapping::Purl.for(druid: druid))
  }.compact)
end

# When starting from MODS.
RSpec.shared_examples 'MODS cocina mapping' do
  # Required: mods, cocina
  # Optional: druid, warnings, errors, mods_attributes, skip_normalization

  let(:orig_cocina_description) { Cocina::Models::Description.new(add_purl_and_title(cocina, local_druid)) }

  let(:orig_mods_ng) { ng_mods_for(mods, mods_attributes) }

  let(:mods_attributes) { MODS_ATTRIBUTES }

  let(:local_druid) { defined?(druid) ? druid : 'druid:zn746hz1696' }

  let(:local_warnings) { defined?(warnings) ? warnings : [] }

  let(:local_errors) { defined?(errors) ? errors : [] }

  let(:skip_normalization) { false }

  context 'when mapping from MODS (to cocina)' do
    let(:notifier) { instance_double(Cocina::Models::Mapping::ErrorNotifier) }

    let(:actual_cocina_props) do
      Cocina::Models::Mapping::FromMods::Description.props(mods: orig_mods_ng, druid: local_druid, notifier: notifier)
    end

    before do
      allow(notifier).to receive(:warn)
      allow(notifier).to receive(:error)
    end

    it 'mods snippet(s) produce valid MODS' do
      expect { orig_mods_ng }.not_to raise_error
    end

    it 'cocina hash produces valid cocina Description' do
      cocina_props = actual_cocina_props.deep_dup
      cocina_props[:title] ||= [{ value: 'Placeholder title' }]
      expect { Cocina::Models::Description.new(cocina_props) }.not_to raise_error
    end

    it 'MODS maps to expected cocina' do
      expect(actual_cocina_props).to be_deep_equal(add_purl_and_title(cocina, local_druid))
    end

    it 'notifier receives warning and/or error messages as specified' do
      # TODO: support testing with no title
      Cocina::Models::Mapping::FromMods::Description.props(mods: orig_mods_ng, druid: local_druid, notifier: notifier, title_builder: TestTitleBuilder)
      if local_warnings.empty?
        expect(notifier).not_to have_received(:warn)
      else
        local_warnings.each do |warning|
          if warning.context
            expect(notifier).to have_received(:warn).with(warning.msg,
                                                          warning.context).exactly(warning.times || 1).times
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
end

def ng_mods_for(snippet, mods_attributes)
  xml = <<~XML
    <mods #{mods_attributes}>
      #{snippet}
    </mods>
  XML
  Nokogiri.XML(xml, nil, 'UTF-8', Nokogiri::XML::ParseOptions.new.strict)
end

Notification = Struct.new(:msg, :context, :times)

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
      Cocina::Models::Mapping::FromMods::Title.build(resource_element: resource_element, notifier: notifier,
                                                     require_title: require_title)
    end
  end
end
