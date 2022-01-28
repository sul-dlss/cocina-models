# frozen_string_literal: true

module Cocina
  module Models
    class LocationBasedAccess < Struct
      # Access level.
      attribute :view, Types::Strict::String.enum('location-based')
      # Download access level.
      attribute :download, Types::Strict::String.enum('location-based', 'none')
      # If access or download is "location-based", which location should have access.
      attribute :location, Types::Strict::String.enum('spec', 'music', 'ars', 'art', 'hoover', 'm&m')
      attribute :controlled_digital_lending, Types::Strict::Bool.enum(false).meta(omittable: true)
    end
  end
end
