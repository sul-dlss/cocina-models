# frozen_string_literal: true

module Cocina
  module Models
    class Embargo < Struct
      # Access level.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :view, Types::Strict::String.optional.default('dark')
      # Download access level.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :download, Types::Strict::String.optional.default('none')
      # Not used for this access type, must be null.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :location, Types::Strict::String.optional
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :controlled_digital_lending, Types::Strict::Bool.optional
      # Date when the Collection is released from an embargo.
      # example: 2029-06-22T07:00:00.000+00:00
      attribute :release_date, Types::Params::DateTime
      # The human readable use and reproduction statement that applies when the embargo expires.
      # example: These materials are in the public domain.
      attribute? :use_and_reproduction_statement, Types::Strict::String.optional

      alias controlledDigitalLending controlled_digital_lending
      deprecation_deprecate :controlledDigitalLending
      alias releaseDate release_date
      deprecation_deprecate :releaseDate
      alias useAndReproductionStatement use_and_reproduction_statement
      deprecation_deprecate :useAndReproductionStatement
    end
  end
end
