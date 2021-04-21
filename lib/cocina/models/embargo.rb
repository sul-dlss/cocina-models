# frozen_string_literal: true

module Cocina
  module Models
    class Embargo < Struct
      # Access level.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :access, Types::Strict::String.optional.default('dark').meta(omittable: true)
      # Download access level.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :download, Types::Strict::String.optional.default('none').meta(omittable: true)
      # If access is "location-based", which location should have access.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :readLocation, Types::Strict::String.optional.meta(omittable: true)
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute :controlledDigitalLending, Types::Strict::Bool.optional.meta(omittable: true)
      # Date when the Collection is released from an embargo.
      # example: 2029-06-22T07:00:00.000+00:00
      attribute :releaseDate, Types::Params::DateTime
      # The human readable use and reproduction statement that applies when the embargo expires.
      # example: These materials are in the public domain.
      attribute :useAndReproductionStatement, Types::Strict::String.meta(omittable: true)
    end
  end
end
