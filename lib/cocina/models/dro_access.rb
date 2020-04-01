# frozen_string_literal: true

module Cocina
  module Models
    class DROAccess < Struct
      attribute :access, Types::Strict::String.default('dark').enum('world', 'stanford', 'location-based', 'citation-only', 'dark').meta(omittable: true)
      # The human readable copyright statement that applies
      # example: Copyright World Trade Organization
      attribute :copyright, Types::Strict::String.meta(omittable: true)
      # If access is "location-based", which location should have access. This is used in the transition from Fedora as a way to set a default readLocation at registration that is copied down to all the files.

      attribute :readLocation, Types::Strict::String.enum('spec', 'music', 'ars', 'art', 'hoover', 'm&m').meta(omittable: true)
      # The human readable use and reproduction statement that applies
      # example: Property rights reside with the repository. Literary rights reside with the creators of the documents or their heirs. To obtain permission to publish or reproduce, please contact the Public Services Librarian of the Dept. of Special Collections (http://library.stanford.edu/spc).
      attribute :useAndReproductionStatement, Types::Strict::String.meta(omittable: true)
      attribute :embargo, Embargo.optional.meta(omittable: true)
    end
  end
end
