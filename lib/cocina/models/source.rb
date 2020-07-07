# frozen_string_literal: true

module Cocina
  module Models
    class Source < Struct
      # Code representing the value source.
      attribute :code, Types::Strict::String.meta(omittable: true)
      # URI for the value source.
      attribute :uri, Types::Strict::String.meta(omittable: true)
      # String describing the value source.
      attribute :value, Types::Strict::String.meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
    end
  end
end
