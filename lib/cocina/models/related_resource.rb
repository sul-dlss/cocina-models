# frozen_string_literal: true

module Cocina
  module Models
    class RelatedResource < Struct
      # The relationship of the related resource to the described resource.
      attribute :type, Types::Strict::String.meta(omittable: true)
      # Status of the related resource relative to other related resources.
      attribute :status, Types::Strict::String.meta(omittable: true)
      # The preferred display label to use for the related resource in access systems.
      attribute :display_label, Types::Strict::String.meta(omittable: true)
      attribute :title, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      attribute :event, Types::Strict::Array.of(Event).default([].freeze)
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :language, Types::Strict::Array.of(Language).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :standard, Standard.optional.meta(omittable: true)
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Stanford persistent URL associated with the related resource. Note this is http, not https.
      attribute :purl, Types::Strict::String.meta(omittable: true)
      attribute :access, DescriptiveAccessMetadata.optional.meta(omittable: true)
      attribute :related_resource, Types::Strict::Array.of(RelatedResource).default([].freeze)
      attribute :admin_metadata, DescriptiveAdminMetadata.optional.meta(omittable: true)
      # The version of the related resource.
      attribute :version, Types::Strict::String.meta(omittable: true)
      # URL or other pointer to the location of the related resource information.
      attribute :value_at, Types::Strict::String.meta(omittable: true)

      def method_missing(method_name, *arguments, &block)
        if %i[displayLabel relatedResource adminMetadata valueAt].include?(method_name)
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
        %i[displayLabel relatedResource adminMetadata valueAt].include?(method_name) || super
      end
    end
  end
end
