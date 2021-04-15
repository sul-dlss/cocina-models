# frozen_string_literal: true

module Cocina
  module Models
    class Embargo < Struct
      # Date when the Collection is released from an embargo.
      # example: 2029-06-22T07:00:00.000+00:00
      attribute :releaseDate, Types::Params::DateTime
      # Access level that applies when embargo expires.
      attribute :access, Types::Strict::String.default('dark').enum('world', 'stanford', 'location-based', 'citation-only', 'dark')
      # Download access level. This is used in the transition from Fedora as a way to set a default download level at registration that is copied down to all the files.

      attribute :download, Types::Strict::String.default('none').enum('world', 'stanford', 'location-based', 'none').meta(omittable: true)
      # If access is "location-based", which location should have access.
      attribute :readLocation, Types::Strict::String.optional.enum('spec', 'music', 'ars', 'art', 'hoover', 'm&m').meta(omittable: true)
      # The human readable use and reproduction statement that applies when the embargo expires.
      # example: These materials are in the public domain.
      attribute :useAndReproductionStatement, Types::Strict::String.meta(omittable: true)
    end
  end
end
