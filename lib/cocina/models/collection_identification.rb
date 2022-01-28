# frozen_string_literal: true

module Cocina
  module Models
    class CollectionIdentification < Struct
      attribute :catalog_links, Types::Strict::Array.of(CatalogLink).default([].freeze)
      # Unique identifier in some other system. This is because a large proportion of what is deposited in SDR, historically and currently, are representations of objects that are also represented in other systems. For example, digitized paper and A/V collections have physical manifestations, and those physical objects are managed in systems that have their own identifiers. Similarly, books have barcodes, archival materials have collection numbers and physical locations, etc. The sourceId allows determining if an item has been deposited before and where to look for the original item if you're looking at its SDR representation. The format is: "namespace:identifier"

      # example: sul:PC0170_s3_Fiesta_Bowl_2012-01-02_210609_2026
      attribute :source_id, Types::Strict::String.meta(omittable: true)

      def method_missing(method_name, *arguments, &block)
        if %i[catalogLinks sourceId].include?(method_name)
          Deprecation.warn(
            self,
            "the `#{method_name}` attribute is deprecated and will be removed in the cocina-models 1.0.0 release"
          )
          public_send(method_name.to_s.underscore, *arguments, &block)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        %i[catalogLinks sourceId].include?(method_name) || super
      end
    end
  end
end
