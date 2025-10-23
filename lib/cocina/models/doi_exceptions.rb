# frozen_string_literal: true

module Cocina
  module Models
    # Exceptions to the DOI pattern for SDR objects are allowed in limited cases: 1) DOIs registered before an SDR object has been registered---i.e., before it has a druid---which is a common pattern as of 2025; and 2) a DOI registered under the Stanford Libraries namespace (10.25936) instead of the SDR one (10.25740). Please note that DOIs are *not* case-sensitive so both cases of letters should be permitted.
    DoiExceptions = Types::String.constrained(format: %r{^10\.(25740/[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}|25936/629[tT]-[bB][xX]79)$})
  end
end
