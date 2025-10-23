# frozen_string_literal: true

module Cocina
  module Models
    # A record identifier migrated from Symphony
    MigratedFromSymphonyIdentifier = Types::String.constrained(format: /^a\d+$/)
  end
end
