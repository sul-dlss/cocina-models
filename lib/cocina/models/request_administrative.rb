# frozen_string_literal: true

module Cocina
  module Models
    class RequestAdministrative < Struct
      # example: druid:bc123df4567
      attribute :hasAdminPolicy, Types::Strict::String
      attribute :releaseTags, Types::Strict::Array.of(ReleaseTag).default([].freeze)
      # Internal project this resource is a part of. This governs routing of messages about this object.
      # example: Google Books
      attribute :partOfProject, Types::Strict::String.meta(omittable: true)
    end
  end
end
