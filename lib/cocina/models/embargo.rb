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
      attribute? :controlledDigitalLending, Types::Strict::Bool.optional.default(false)
      # Date when the Collection is released from an embargo.
      # example: 2029-06-22T07:00:00.000+00:00
      attribute :releaseDate, Types::Params::DateTime
      # The human readable use and reproduction statement that applies
      # example: Property rights reside with the repository. Literary rights reside with the creators of the documents or their heirs. To obtain permission to publish or reproduce, please contact the Public Services Librarian of the Dept. of Special Collections (http://library.stanford.edu/spc).
      attribute? :useAndReproductionStatement, UseAndReproductionStatement.optional
    end
  end
end
