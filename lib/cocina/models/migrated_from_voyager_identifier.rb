# frozen_string_literal: true

module Cocina
  module Models
    # A record identifier migrated from Voyager
    # example: L11403803
    MigratedFromVoyagerIdentifier = Types::String.constrained(format: /^L\d+$/)
  end
end
