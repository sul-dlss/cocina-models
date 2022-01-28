# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveParallelContributor < Struct
      attribute :name, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Entity type of the contributor (person, organization, etc.).
      attribute :type, Types::Strict::String.meta(omittable: true)
      # Status of the contributor relative to other parallel contributors (e.g. the primary author among a group of contributors).
      attribute :status, Types::Strict::String.meta(omittable: true)
      attribute :role, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # URL or other pointer to the location of the contributor information.
      attribute :value_at, Types::Strict::String.meta(omittable: true)
      attribute :value_language, DescriptiveValueLanguage.optional.meta(omittable: true)

      def method_missing(method_name, *arguments, &block)
        if %i[valueAt valueLanguage].include?(method_name)
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
        %i[valueAt valueLanguage].include?(method_name) || super
      end
    end
  end
end
