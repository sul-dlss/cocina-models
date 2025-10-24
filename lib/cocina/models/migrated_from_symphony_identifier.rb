# frozen_string_literal: true

module Cocina
  module Models
    # A record identifier migrated from Symphony
    # example: a11403803
    MigratedFromSymphonyIdentifier = Types::String.constrained(format: /^a\d+$/)
  end
end
