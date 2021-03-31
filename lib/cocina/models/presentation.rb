# frozen_string_literal: true

module Cocina
  module Models
    class Presentation < Struct
      # Height in pixels
      attribute :height, Types::Strict::Integer.meta(omittable: true)
      # Width in pixels
      attribute :width, Types::Strict::Integer.meta(omittable: true)
    end
  end
end
