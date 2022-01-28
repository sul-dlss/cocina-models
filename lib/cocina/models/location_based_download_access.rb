# frozen_string_literal: true

module Cocina
  module Models
    class LocationBasedDownloadAccess < Struct
      # Access level.
      attribute :view, Types::Strict::String.enum('stanford', 'world')
      # Download access level.
      attribute :download, Types::Strict::String.enum('location-based')
      # Which location should have download access.
      attribute :location, Types::Strict::String.enum('spec', 'music', 'ars', 'art', 'hoover', 'm&m')
      attribute? :controlled_digital_lending, Types::Strict::Bool.enum(false)

      alias controlledDigitalLending controlled_digital_lending
      deprecation_deprecate :controlledDigitalLending
    end
  end
end
