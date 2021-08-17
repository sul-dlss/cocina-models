# frozen_string_literal: true

module Cocina
  module Models
    Purl = Types::String.constrained(
      format: %r{^https://}i
    )
  end
end
