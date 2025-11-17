# frozen_string_literal: true

module Cocina
  module Models
    # A barcode
    class Barcode < BaseModel
      # Union of: BusinessBarcode, LaneMedicalBarcode, CatkeyBarcode, StandardBarcode
    end
  end
end
