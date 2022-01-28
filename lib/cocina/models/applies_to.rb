# frozen_string_literal: true

module Cocina
  module Models
    class AppliesTo < Struct
      attribute :applies_to, Types::Strict::Array.of(DescriptiveBasicValue).default([].freeze)

      def method_missing(method_name, *arguments, &block)
        if [:appliesTo].include?(method_name)
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
        [:appliesTo].include?(method_name) || super
      end
    end
  end
end
