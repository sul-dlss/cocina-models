# frozen_string_literal: true

module Cocina
  module Models
    # Property model for indicating the encoding, standard, or syntax to which a value
    # conforms (e.g. RDA).
    class Standard < BaseModel
      attr_accessor :code, :uri, :value, :note, :version, :source
    end
  end
end
