# frozen_string_literal: true

module Cocina
  module Models
    class LocationBasedDownloadAccess < Struct
      # Access level.
      attribute :access, Types::Strict::String.enum('stanford', 'world')
      # Download access level.
      attribute :download, Types::Strict::String.enum('location-based')
      # If access is "location-based", which location should have access.
      attribute :readLocation, Types::Strict::String.enum('spec', 'music', 'ars', 'art', 'hoover', 'm&m')
      attribute :controlledDigitalLending, Types::Strict::Bool.enum(false).meta(omittable: true)
    end
  end
end
