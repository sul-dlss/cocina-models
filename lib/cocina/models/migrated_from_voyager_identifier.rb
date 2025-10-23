# frozen_string_literal: true

module Cocina
  module Models
    # A record identifier migrated from Voyager
    MigratedFromVoyagerIdentifier = Types::String.constrained(format: /^L\d+$/)
  end
end
