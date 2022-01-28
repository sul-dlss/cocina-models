# frozen_string_literal: true

module Cocina
  module Models
    class CatalogLink < Struct
      # Catalog that is the source of the linked record.
      # example: symphony
      attribute :catalog, Types::Strict::String
      # Record identifier that is unique within the context of the linked record's catalog.
      # example: 11403803
      attribute :catalog_record_id, Types::Strict::String

      def method_missing(method_name, *arguments, &block)
        if [:catalogRecordId].include?(method_name)
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
        [:catalogRecordId].include?(method_name) || super
      end
    end
  end
end
