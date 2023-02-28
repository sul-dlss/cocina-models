# frozen_string_literal: true

module Cocina
  module Models
    CocinaVersion = Types::String.constrained(format: /^\d+\.\d+\.\d+$/)
  end
end
