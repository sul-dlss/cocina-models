# frozen_string_literal: true

module Cocina
  module Models
    class Presentation < Struct
      attribute :height, Types::Strict::Integer.meta(omittable: true)
      attribute :width, Types::Strict::Integer.meta(omittable: true)
    end
  end
end
