# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMods
        # Maps MODS identifer to cocina identifier
        class Identifier
          # @param [Nokogiri::XML::Element] resource_element mods or relatedItem element
          # @param [Cocina::Models::Mapping::FromMods::DescriptionBuilder] description_builder
          # @param [String] purl
          # @return [Hash] a hash that can be mapped to a cocina model
          def self.build(resource_element:, description_builder: nil, purl: nil)
            new(resource_element: resource_element).build
          end

          def initialize(resource_element:)
            @resource_element = resource_element
          end

          def build
            altrepgroup_identifier_nodes, other_identifier_nodes = AltRepGroup.split(nodes: identifiers)

            altrepgroup_identifier_nodes.map { |id_nodes| build_parallel(id_nodes) } +
              other_identifier_nodes.map do |id_node|
                IdentifierBuilder.build_from_identifier(identifier_element: id_node)
              end
          end

          private

          attr_reader :resource_element

          def build_parallel(identifier_nodes)
            {
              parallelValue: identifier_nodes.map do |id_node|
                               IdentifierBuilder.build_from_identifier(identifier_element: id_node)
                             end
            }
          end

          def identifiers
            (resource_element.xpath('mods:identifier', mods: Description::DESC_METADATA_NS) +
              resource_element.xpath('mods:recordIdentifier',
                                     mods: Description::DESC_METADATA_NS)).reject { |identifier_node| identifier_node.text.blank? && identifier_node.attributes.empty? }
          end
        end
      end
    end
  end
end
