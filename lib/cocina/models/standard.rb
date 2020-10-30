# frozen_string_literal: true

module Cocina
  module Models
    class Standard < Struct
      # Code representing the standard or encoding.
      attribute :code, Types::Strict::String.meta(omittable: true)
      # URI for the standard or encoding.
      attribute :uri, Types::Strict::String.meta(omittable: true)
      # String describing the standard or encoding.
      attribute :value, Types::Strict::String.meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      # The version of the standard or encoding.
      attribute :version, Types::Strict::String.meta(omittable: true)
      attribute :source, Source.optional.meta(omittable: true)
      # Type of value provided by the descriptive element.
      attribute :type, Types::Strict::String.meta(omittable: true)
    end
  end
end
