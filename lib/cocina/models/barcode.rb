# frozen_string_literal: true

module Cocina
  module Models
    Barcode = Types::String.constrained(
      format: /^[0-9]{12,20}$/i
    )
  end
end
