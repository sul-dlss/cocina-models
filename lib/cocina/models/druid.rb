# frozen_string_literal: true

module Cocina
  module Models
    Druid = Types::String.constrained(
      format: /^druid:[b-df-hjkmnp-tv-z]{2}[0-9]{3}[b-df-hjkmnp-tv-z]{2}[0-9]{4}$/i
    )
  end
end
