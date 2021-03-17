# frozen_string_literal: true

module Cocina
  module Models
    class Access < Struct
      # Access level
      attribute :access, Types::Strict::String.default('dark').enum('world', 'stanford', 'location-based', 'citation-only', 'dark').meta(omittable: true)
      # If access is "location-based", which location should have access.
      attribute :readLocation, Types::Strict::String.enum('spec', 'music', 'ars', 'art', 'hoover', 'm&m').meta(omittable: true)
      # The human readable use and reproduction statement that applies
      # example: Property rights reside with the repository. Literary rights reside with the creators of the documents or their heirs. To obtain permission to publish or reproduce, please contact the Public Services Librarian of the Dept. of Special Collections (http://library.stanford.edu/spc).
      attribute :useAndReproductionStatement, Types::Strict::String.meta(omittable: true)
      # The license governing reuse of the Collection. Should be an IRI for known licenses (i.e. CC, RightsStatement.org URI, etc.).
      attribute :license, Types::Strict::String.meta(omittable: true)
    end
  end
end
