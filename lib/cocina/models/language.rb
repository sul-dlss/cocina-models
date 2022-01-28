# frozen_string_literal: true

module Cocina
  module Models
    class Language < Struct
      attribute :applies_to, Types::Strict::Array.of(DescriptiveBasicValue).default([].freeze)
      # Code value of the descriptive element.
      attribute :code, Types::Strict::String.meta(omittable: true)
      # The preferred display label to use for the descriptive element in access systems.
      attribute :display_label, Types::Strict::String.meta(omittable: true)
      attribute :encoding, Standard.optional.meta(omittable: true)
      attribute :grouped_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :parallel_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # present for mapping to additional schemas in the future and for consistency but not otherwise used
      attribute :qualifier, Types::Strict::String.meta(omittable: true)
      attribute :script, DescriptiveValue.optional.meta(omittable: true)
      attribute :source, Source.optional.meta(omittable: true)
      # Status of the language relative to other parallel language elements (e.g. the primary language)
      attribute :status, Types::Strict::String.enum('primary').meta(omittable: true)
      attribute :standard, Standard.optional.meta(omittable: true)
      attribute :structured_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # URI value of the descriptive element.
      attribute :uri, Types::Strict::String.meta(omittable: true)
      # Value of the descriptive element.
      attribute :value, Types::Strict::String.meta(omittable: true)
      # URL or other pointer to the location of the language information.
      attribute :value_at, Types::Strict::String.meta(omittable: true)
      attribute :value_language, DescriptiveValueLanguage.optional.meta(omittable: true)

      def method_missing(method_name, *arguments, &block)
        if %i[appliesTo displayLabel groupedValue parallelValue structuredValue valueAt
              valueLanguage].include?(method_name)
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
        %i[appliesTo displayLabel groupedValue parallelValue structuredValue valueAt
           valueLanguage].include?(method_name) || super
      end
    end
  end
end
