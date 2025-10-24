# frozen_string_literal: true

module Cocina
  module Models
    # The version of Cocina with which this object conforms.
    # example: 1.2.3
    CocinaVersion = Types::String.constrained(format: /^\d+\.\d+\.\d+$/)
  end
end
