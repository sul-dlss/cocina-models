# frozen_string_literal: true

module Cocina
  module Models
    # The DOI (Digital Object Identifier, https://www.doi.org) pattern for works registered
    # by Stanford Libraries outside of SDR workflows. Please note that DOIs are *not* case-sensitive
    # so both cases of letters should be permitted.
    LibrariesDOI = Types::String.constrained(format: %r{^10\.25936/[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}$})
  end
end
