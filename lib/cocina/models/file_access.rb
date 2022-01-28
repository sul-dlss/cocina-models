# frozen_string_literal: true

module Cocina
  module Models
    class FileAccess < Struct
      # Access level.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :view, Types::Strict::String.optional.default('dark').meta(omittable: true)
      # Download access level.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :download, Types::Strict::String.optional.default('none').meta(omittable: true)
      # Not used for this access type, must be null.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :location, Types::Strict::String.optional.meta(omittable: true)
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :controlled_digital_lending, Types::Strict::Bool.optional.meta(omittable: true)

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
