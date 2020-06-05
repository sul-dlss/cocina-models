# frozen_string_literal: true

module Cocina
  module Models
    class Standard < Struct
      # Code representing the value standard or encoding.
      attribute :code, Types::Strict::String.meta(omittable: true)
      # URI for the value standard or encoding.
      attribute :uri, Types::Strict::String.meta(omittable: true)
      # String describing the value standard or encoding.
      attribute :value, Types::Strict::String.meta(omittable: true)
      # Other information related to the value standard or encoding.
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      # Source of a code or URI.
      attribute :source, Source.optional.meta(omittable: true)
    end
  end
end
