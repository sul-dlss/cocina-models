# frozen_string_literal: true

module Cocina
  module Models
    class Administrative < Struct
      # example: druid:bc123df4567
      attribute :hasAdminPolicy, Types::Strict::String.meta(omittable: true)
      attribute :releaseTags, Types::Strict::Array.of(ReleaseTag).default([].freeze)
      # Administrative or Internal project this resource is a part of
      # example: Google Books
      attribute :partOfProject, Types::Strict::String.meta(omittable: true)
    end
  end
end
