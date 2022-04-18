# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicyAccessTemplate < Struct
      attribute? :view, Types::Strict::String.enum('world', 'stanford', 'location-based', 'citation-only', 'dark')
      # Available for controlled digital lending.
      attribute? :controlledDigitalLending, Types::Strict::Bool
      # The human readable copyright statement that applies
      # example: Copyright World Trade Organization
      attribute? :copyright, Types::Strict::String.optional
      # Download access level. This is used in the transition from Fedora as a way to set a default download level at registration that is copied down to all the files.

      attribute? :download, Types::Strict::String.enum('world', 'stanford', 'location-based', 'none')
      # If access or download is "location-based", this indicates which location should have access. This is used in the transition from Fedora as a way to set a default location at registration that is copied down to all the files.

      attribute? :location, Types::Strict::String.optional.enum('spec', 'music', 'ars', 'art', 'hoover', 'm&m')
      # The human readable use and reproduction statement that applies
      # example: Property rights reside with the repository. Literary rights reside with the creators of the documents or their heirs. To obtain permission to publish or reproduce, please contact the Public Services Librarian of the Dept. of Special Collections (http://library.stanford.edu/spc).
      attribute? :useAndReproductionStatement, Types::Strict::String.optional
      # The license governing reuse of the Collection. Should be an IRI for known licenses (i.e. CC, RightsStatement.org URI, etc.).
      attribute? :license, Types::Strict::String.optional
    end
  end
end
