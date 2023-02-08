# frozen_string_literal: true

module Cocina
  module Models
    MigratedFromSymphonyIdentifier = Types::String.constrained(
      format: /^a\d+$/
    )
  end
end
