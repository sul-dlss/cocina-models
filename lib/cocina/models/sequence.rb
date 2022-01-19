# frozen_string_literal: true

module Cocina
  module Models
    class Sequence < Struct
      attribute :members, Types::Strict::Array.of(Types::Strict::String).meta(omittable: true)
      # The direction that a sequence of canvases should be displayed to the user
      attribute :viewingDirection, Types::Strict::String.enum('right-to-left', 'left-to-right').meta(omittable: true)
    end
  end
end
