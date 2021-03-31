# frozen_string_literal: true

module Cocina
  module Models
    class Administrative < Struct
      # example: druid:bc123df4567
      attribute :hasAdminPolicy, Types::Strict::String
      attribute :releaseTags, Types::Strict::Array.of(ReleaseTag).meta(omittable: true)
      # Administrative or Internal project this resource is a part of
      # example: Google Books
      attribute :partOfProject, Types::Strict::String.optional.meta(omittable: true)
    end
  end
end
