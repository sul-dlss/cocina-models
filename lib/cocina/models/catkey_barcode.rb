# frozen_string_literal: true

module Cocina
  module Models
    # The barcode associated with a DRO object based on catkey, prefixed with a catkey
    # followed by a hyphen
    # example: 6772719-1001
    CatkeyBarcode = Types::String.constrained(format: /^[0-9]+-[0-9]+$/)
  end
end
