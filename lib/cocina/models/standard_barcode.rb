# frozen_string_literal: true

module Cocina
  module Models
    StandardBarcode = Types::String.constrained(
      format: /^36105[0-9]{9}$/
    )
  end
end
