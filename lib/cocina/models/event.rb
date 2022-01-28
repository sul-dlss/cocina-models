# frozen_string_literal: true

module Cocina
  module Models
    class Event < Struct
      attribute :structured_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Description of the event (creation, publication, etc.).
      attribute :type, Types::Strict::String.meta(omittable: true)
      # The preferred display label to use for the event in access systems.
      attribute :display_label, Types::Strict::String.meta(omittable: true)
      attribute :date, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      attribute :location, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :value_language, DescriptiveValueLanguage.optional.meta(omittable: true)
      attribute :parallel_event, Types::Strict::Array.of(DescriptiveParallelEvent).default([].freeze)

      def method_missing(method_name, *arguments, &block)
        if %i[structuredValue displayLabel valueLanguage parallelEvent].include?(method_name)
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
        %i[structuredValue displayLabel valueLanguage parallelEvent].include?(method_name) || super
      end
    end
  end
end
