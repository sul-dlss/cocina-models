# frozen_string_literal: true

module Cocina
  module Models
    # The barcode associated with a business library DRO object, prefixed with 2050
    BusinessBarcode = Types::String.constrained(format: /^2050[0-9]{7}$/)
  end
end
