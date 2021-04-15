# frozen_string_literal: true

module Cocina
  module Models
    class FileAccess < Struct
      # Access level that applies when embargo expires.
      attribute :access, Types::Strict::String.default('dark').enum('world', 'stanford', 'location-based', 'citation-only', 'dark').meta(omittable: true)
      # Available for controlled digital lending.
      attribute :controlledDigitalLending, Types::Strict::Bool.meta(omittable: true)
      # Download access level. This is used in the transition from Fedora as a way to set a default download level at registration that is copied down to all the files.

      attribute :download, Types::Strict::String.default('none').enum('world', 'stanford', 'location-based', 'none').meta(omittable: true)
      # If access is "location-based", which location should have access.
      attribute :readLocation, Types::Strict::String.optional.enum('spec', 'music', 'ars', 'art', 'hoover', 'm&m').meta(omittable: true)
    end
  end
end
