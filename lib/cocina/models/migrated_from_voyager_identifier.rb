# frozen_string_literal: true

module Cocina
  module Models
    MigratedFromVoyagerIdentifier = Types::String.constrained(
      format: /^L\d+$/
    )
  end
end
