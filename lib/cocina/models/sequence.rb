# frozen_string_literal: true

module Cocina
  module Models
    # Metadata for a sequence.  See http://sul-dlss.github.io/cocina-models/maps/Sequence.json
    class Sequence < Struct
      attribute :viewingDirection, Types::String.enum('left-to-right',
                                                      'right-to-left',
                                                      'top-to-bottom',
                                                      'bottom-to-top').optional
    end
  end
end
