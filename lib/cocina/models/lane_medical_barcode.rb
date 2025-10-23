# frozen_string_literal: true

module Cocina
  module Models
    # The barcode associated with a Lane Medical Library DRO object, prefixed with 245
    LaneMedicalBarcode = Types::String.constrained(format: /^245[0-9]{8}$/)
  end
end
