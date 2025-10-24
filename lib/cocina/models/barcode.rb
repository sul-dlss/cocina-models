# frozen_string_literal: true

module Cocina
  module Models
    # A barcode
    Barcode = BusinessBarcode | LaneMedicalBarcode | CatkeyBarcode | StandardBarcode
  end
end
