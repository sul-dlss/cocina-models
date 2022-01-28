# frozen_string_literal: true

module Cocina
  module Models
    class CitationOnlyAccess < Struct
      # Access level.
      attribute :view, Types::Strict::String.enum('citation-only')
      # Download access level.
      attribute :download, Types::Strict::String.enum('none')
      # Not used for this access type, must be null.
      attribute :location, Types::Strict::String.optional.enum('').meta(omittable: true)
      attribute :controlled_digital_lending, Types::Strict::Bool.enum(false).meta(omittable: true)

      def method_missing(method_name, *arguments, &block)
        if [:controlledDigitalLending].include?(method_name)
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
        [:controlledDigitalLending].include?(method_name) || super
      end
    end
  end
end
