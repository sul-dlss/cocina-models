# frozen_string_literal: true

module Cocina
  module Models
    # The version of Cocina with which this object conforms.
    CocinaVersion = Types::String.constrained(format: /^\d+\.\d+\.\d+$/)
  end
end
