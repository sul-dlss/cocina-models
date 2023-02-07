# frozen_string_literal: true

module Cocina
  module Models
    LaneMedicalBarcode = Types::String.constrained(
      format: /^245[0-9]{8}$/
    )
  end
end
