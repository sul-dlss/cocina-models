# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveValueLanguage < Struct
      # Code representing the standard or encoding.
      attribute? :code, Types::Strict::String
      # URI for the standard or encoding.
      attribute? :uri, Types::Strict::String
      # String describing the standard or encoding.
      attribute? :value, Types::Strict::String
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # The version of the standard or encoding.
      attribute? :version, Types::Strict::String
      attribute? :source, Source.optional
      attribute? :valueScript, Standard.optional
    end
  end
end
