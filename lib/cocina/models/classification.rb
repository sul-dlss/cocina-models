# frozen_string_literal: true

module Cocina
  module Models
    class Classification < Struct
      attribute :authority, Types::Strict::String.meta(omittable: true)
      attribute :displayLabel, Types::Strict::String.meta(omittable: true)
      attribute :edition, Types::Strict::String.meta(omittable: true)
    end
  end
end
