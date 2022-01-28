# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveAccessMetadata < Struct
      attribute :url, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :physical_location, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :digital_location, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :access_contact, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :digital_repository, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)

      def method_missing(method_name, *arguments, &block)
        if %i[physicalLocation digitalLocation accessContact digitalRepository].include?(method_name)
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
        %i[physicalLocation digitalLocation accessContact digitalRepository].include?(method_name) || super
      end
    end
  end
end
