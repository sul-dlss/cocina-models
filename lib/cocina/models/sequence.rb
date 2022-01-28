# frozen_string_literal: true

module Cocina
  module Models
    class Sequence < Struct
      attribute :members, Types::Strict::Array.of(Types::Strict::String).default([].freeze)
      # The direction that a sequence of canvases should be displayed to the user
      attribute? :viewing_direction, Types::Strict::String.enum('right-to-left', 'left-to-right')

      alias viewingDirection viewing_direction
      deprecation_deprecate :viewingDirection
    end
  end
end
