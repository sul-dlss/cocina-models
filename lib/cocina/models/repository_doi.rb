# frozen_string_literal: true

module Cocina
  module Models
    # The DOI (Digital Object Identifier, https://www.doi.org) pattern for SDR objects,
    # based on the object's repository identifier. Permits both production and text prefixes
    # to be used to account for objects in different SDR environments. Please note that
    # while DOIs are *not* case-sensitive, we constrain the DOIs we mint for SDR to lowercase
    # for consistency.
    # example: 10.25740/bc123df4567
    RepositoryDOI = String
  end
end
