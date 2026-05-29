# frozen_string_literal: true

module Cocina
  module Models
    # The barcode associated with a CHS DRO, prefixed with 405
    # example: 405000111956
    CaliforniaHistoricalSocietyBarcode = Types::String.constrained(format: /^405[0-9]{9}$/)
  end
end
