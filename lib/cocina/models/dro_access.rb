# frozen_string_literal: true

module Cocina
  module Models
    class DROAccess < Struct
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
      # The human readable copyright statement that applies
      # example: Copyright World Trade Organization
      attribute :copyright, Types::Strict::String.optional.meta(omittable: true)
      attribute :embargo, Embargo.optional.meta(omittable: true)
      # The human readable use and reproduction statement that applies
      # example: Property rights reside with the repository. Literary rights reside with the creators of the documents or their heirs. To obtain permission to publish or reproduce, please contact the Public Services Librarian of the Dept. of Special Collections (http://library.stanford.edu/spc).
      attribute :useAndReproductionStatement, Types::Strict::String.meta(omittable: true)
      # The license governing reuse of the DRO. Should be an IRI for known licenses (i.e. CC, RightsStatement.org URI, etc.).
      attribute :license, Types::Strict::String.meta(omittable: true)
    end
  end
end
