# frozen_string_literal: true

module Cocina
  module Models
    class Sequence < Struct
      attribute :viewingDirection, Types::Strict::String.enum('right-to-left', 'left-to-right').meta(omittable: true)
    end
  end
end
