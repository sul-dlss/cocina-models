# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveGroupedValue < Struct
      attribute :grouped_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)

      def method_missing(method_name, *arguments, &block)
        if [:groupedValue].include?(method_name)
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
        [:groupedValue].include?(method_name) || super
      end
    end
  end
end
