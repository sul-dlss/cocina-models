# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveValueLanguage < Struct
      # Code representing the standard or encoding.
      attribute :code, Types::Strict::String.meta(omittable: true)
      # URI for the standard or encoding.
      attribute :uri, Types::Strict::String.meta(omittable: true)
      # String describing the standard or encoding.
      attribute :value, Types::Strict::String.meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :source, Source.optional.meta(omittable: true)
      attribute :valueScript, Standard.optional.meta(omittable: true)
    end
  end
end
