# frozen_string_literal: true

module Cocina
  module Models
    class Source < Struct
      # Code representing the value source.
      attribute? :code, Types::Strict::String
      # URI for the value source.
      attribute? :uri, Types::Strict::String
      # String describing the value source.
      attribute? :value, Types::Strict::String
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # The version of the value source.
      attribute? :version, Types::Strict::String
    end
  end
end
