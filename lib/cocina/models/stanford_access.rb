# frozen_string_literal: true

module Cocina
  module Models
    class StanfordAccess < Struct
      # Access level.
      attribute :access, Types::Strict::String.enum('stanford')
      # Download access level.
      attribute :download, Types::Strict::String.enum('stanford')
      # If access is "location-based", which location should have access.
      attribute :readLocation, Types::Strict::String.optional.enum('').meta(omittable: true)
      attribute :controlledDigitalLending, Types::Strict::Bool.enum(false).meta(omittable: true)
    end
  end
end
