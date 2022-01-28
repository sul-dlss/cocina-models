# frozen_string_literal: true

module Cocina
  module Models
    class Description < Struct
      include Validatable

      attribute :title, Types::Strict::Array.of(Title).default([].freeze)
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      attribute :event, Types::Strict::Array.of(Event).default([].freeze)
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :geographic, Types::Strict::Array.of(DescriptiveGeographicMetadata).default([].freeze)
      attribute :language, Types::Strict::Array.of(Language).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :access, DescriptiveAccessMetadata.optional.meta(omittable: true)
      attribute :related_resource, Types::Strict::Array.of(RelatedResource).default([].freeze)
      attribute :marc_encoded_data, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :admin_metadata, DescriptiveAdminMetadata.optional.meta(omittable: true)
      # URL or other pointer to the location of the resource description.
      attribute :value_at, Types::Strict::String.meta(omittable: true)
      # Stanford persistent URL associated with the related resource. Note this is http, not https.
      attribute :purl, Types::Strict::String

      def method_missing(method_name, *arguments, &block)
        if %i[relatedResource marcEncodedData adminMetadata valueAt].include?(method_name)
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
        %i[relatedResource marcEncodedData adminMetadata valueAt].include?(method_name) || super
      end
    end
  end
end
