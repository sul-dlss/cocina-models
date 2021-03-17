# frozen_string_literal: true

module Cocina
  module Models
    CatkeyBarcode = Types::String.constrained(
      format: /^[0-9]+-[0-9]+$/i
    )
  end
end
