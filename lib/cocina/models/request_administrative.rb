# frozen_string_literal: true

module Cocina
  module Models
    class RequestAdministrative < Struct
      # example: druid:bc123df4567
      attribute :has_admin_policy, Types::Strict::String
      attribute :release_tags, Types::Strict::Array.of(ReleaseTag).default([].freeze)
      # Internal project this resource is a part of. This governs routing of messages about this object.
      # example: Google Books
      attribute? :part_of_project, Types::Strict::String

      alias hasAdminPolicy has_admin_policy
      deprecation_deprecate :hasAdminPolicy
      alias releaseTags release_tags
      deprecation_deprecate :releaseTags
      alias partOfProject part_of_project
      deprecation_deprecate :partOfProject
    end
  end
end
