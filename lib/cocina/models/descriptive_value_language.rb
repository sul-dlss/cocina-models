# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveValueLanguage < Struct
      # Code representing the standard or encoding.
      attribute :code, Types::Strict::String.meta(omittable: true)
      # URI for the standard or encoding.
      attribute :uri, Types::Strict::String.meta(omittable: true)
      # String describing the standard or encoding.
      attribute :value, Types::Strict::String.meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # The version of the standard or encoding.
      attribute :version, Types::Strict::String.meta(omittable: true)
      attribute :source, Source.optional.meta(omittable: true)
      attribute :value_script, Standard.optional.meta(omittable: true)

      def method_missing(method_name, *arguments, &block)
        if [:valueScript].include?(method_name)
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
        [:valueScript].include?(method_name) || super
      end
    end
  end
end
