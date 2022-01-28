# frozen_string_literal: true

module Cocina
  module Models
    class RequestAdministrative < Struct
      # example: druid:bc123df4567
      attribute :has_admin_policy, Types::Strict::String
      attribute :release_tags, Types::Strict::Array.of(ReleaseTag).default([].freeze)
      # Internal project this resource is a part of. This governs routing of messages about this object.
      # example: Google Books
      attribute :part_of_project, Types::Strict::String.meta(omittable: true)

      def method_missing(method_name, *arguments, &block)
        if %i[hasAdminPolicy releaseTags partOfProject].include?(method_name)
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
        %i[hasAdminPolicy releaseTags partOfProject].include?(method_name) || super
      end
    end
  end
end
