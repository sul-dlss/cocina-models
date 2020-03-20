# frozen_string_literal: true

module Cocina
  module Models
    class Embargo < Struct
      # Date when the Collection is released from an embargo.
      # example: 2029-06-22T07:00:00.000+00:00
      attribute :releaseDate, Types::Params::DateTime
      # Access level that applies when embargo expires.
      attribute :access, Types::Strict::String.enum('world', 'stanford', 'location-based', 'citation-only', 'dark')
      # The human readable use and reproduction statement that applies when the embargo expires.
      # example: These materials are in the public domain.
      attribute :useAndReproductionStatement, Types::Strict::String.meta(omittable: true)
    end
  end
end
