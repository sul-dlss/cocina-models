# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicyDefaultAccess < Struct
      attribute :access, Types::Strict::String.enum('world', 'stanford', 'location-based', 'citation-only', 'dark').optional.meta(omittable: true)
      # Available for controlled digital lending.
      attribute :controlledDigitalLending, Types::Strict::Bool.optional.meta(omittable: true)
      # The human readable copyright statement that applies
      # example: Copyright World Trade Organization
      attribute :copyright, Types::Strict::String.optional.meta(omittable: true)
      # Download access level. This is used in the transition from Fedora as a way to set a default download level at registration that is copied down to all the files.

      attribute :download, Types::Strict::String.enum('world', 'stanford', 'location-based', 'none').optional.meta(omittable: true)
      # If access is "location-based", which location should have access. This is used in the transition from Fedora as a way to set a default readLocation at registration that is copied down to all the files.

      attribute :readLocation, Types::Strict::String.enum('spec', 'music', 'ars', 'art', 'hoover', 'm&m').optional.meta(omittable: true)
      # The human readable use and reproduction statement that applies
      # example: Property rights reside with the repository. Literary rights reside with the creators of the documents or their heirs. To obtain permission to publish or reproduce, please contact the Public Services Librarian of the Dept. of Special Collections (http://library.stanford.edu/spc).
      attribute :useAndReproductionStatement, Types::Strict::String.optional.meta(omittable: true)
      # The license governing reuse of the Collection. Should be an IRI for known licenses (i.e. CC, RightsStatement.org URI, etc.).
      attribute :license, Types::Strict::String.optional.meta(omittable: true)
    end
  end
end
