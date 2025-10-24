# frozen_string_literal: true

module Cocina
  module Models
    # The DOI (Digital Object Identifier, https://www.doi.org) pattern for objects in SDR
    # that do not adhere to any of the other DOI patterns in the spec. This is a short
    # list of known exceptions only. Please note that DOIs are *not* case-sensitive, so
    # we allow for uppercase and lowercase letters with these exceptions.
    DOIExceptions = Types::String.constrained(format: %r{^10\.25936/[jJ][mM]709[hH][cC]8700|10\.18735/4[nN][sS][eE]-8871|10\.18735/952[xX]-[wW]447|10\.18735/0[mM][wW]1-[qQ][qQ]72$})
  end
end
