# frozen_string_literal: true

module Cocina
  module Models
    class Access < Struct
      # Access level
      attribute :access, Types::Strict::String.default('dark').enum('world', 'stanford', 'location-based', 'citation-only', 'dark').meta(omittable: true)
      # Download access level for a file
      attribute :download, Types::Strict::String.default('none').enum('world', 'stanford', 'location-based', 'none').meta(omittable: true)
      # If access is "location-based", which location should have access.
      attribute :readLocation, Types::Strict::String.enum('spec', 'music', 'ars', 'art', 'hoover', 'm&m').meta(omittable: true)
    end
  end
end
