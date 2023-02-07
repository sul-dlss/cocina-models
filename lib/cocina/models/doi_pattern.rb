# frozen_string_literal: true

module Cocina
  module Models
    DoiPattern = Types::String.constrained(
      format: %r{^10\.(25740|80343)/[b-df-hjkmnp-tv-z]{2}[0-9]{3}[b-df-hjkmnp-tv-z]{2}[0-9]{4}$}
    )
  end
end
