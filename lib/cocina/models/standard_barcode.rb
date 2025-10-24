# frozen_string_literal: true

module Cocina
  module Models
    # The standard barcode associated with a DRO object, prefixed with 36105
    # example: 36105010362304
    StandardBarcode = Types::String.constrained(format: /^36105[0-9]{9}$/)
  end
end
