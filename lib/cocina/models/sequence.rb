# frozen_string_literal: true

module Cocina
  module Models
    # A sequence or ordering of resources within a Collection or Object.
    class Sequence < Struct
      # Identifiers for Members in their stated Order for the Sequence.
      attribute :members, Types::Strict::Array.of(Types::Strict::String).default([].freeze)
      # The direction that a sequence of canvases should be displayed to the user
      attribute? :viewingDirection, Types::Strict::String.enum('right-to-left', 'left-to-right')
    end
  end
end
