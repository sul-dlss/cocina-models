# frozen_string_literal: true

module Cocina
  module Models
    # Validates known formats of:
    #   36105111111111 (Stanford specific barcodes)
    #   1111-1111 (catkey-copynumber)
    Barcode = Types::String.constrained(
      format: /^[0-9]+-[0-9]+$|^36105[0-9]{9}$/i
    )
  end
end
