# frozen_string_literal: true

module Cocina
  module Models
    # The DOI (Digital Object Identifier, https://www.doi.org) pattern for DOIs registered
    # before an SDR object has been registered---i.e., before it has a druid, which is
    # a common pattern as of 2025. Please note that DOIs are *not* case-sensitive so both
    # cases of letters should be permitted.
    # example: 10.80343/12qF-5243
    PreregisteredRepositoryDOI = String
  end
end
