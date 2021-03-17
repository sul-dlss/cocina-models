# frozen_string_literal: true

module Cocina
  module Models
    BusinessBarcode = Types::String.constrained(
      format: /^2050[0-9]{7}$/i
    )
  end
end
