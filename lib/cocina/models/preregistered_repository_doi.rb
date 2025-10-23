# frozen_string_literal: true

module Cocina
  module Models
    # The DOI (Digital Object Identifier, https://www.doi.org) pattern for DOIs registered
    # before an SDR object has been registered---i.e., before it has a druid, which is
    # a common pattern as of 2025. Please note that DOIs are *not* case-sensitive so both
    # cases of letters should be permitted.
    PreregisteredRepositoryDOI = Types::String.constrained(format: %r{^10\.(25740|80343)/[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}$})
  end
end
