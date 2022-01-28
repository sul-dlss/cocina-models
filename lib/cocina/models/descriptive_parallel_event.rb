# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveParallelEvent < Struct
      attribute :structured_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Description of the event (creation, publication, etc.).
      attribute? :type, Types::Strict::String
      # The preferred display label to use for the event in access systems.
      attribute? :display_label, Types::Strict::String
      attribute :date, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      attribute :location, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute? :value_language, DescriptiveValueLanguage.optional

      alias structuredValue structured_value
      deprecation_deprecate :structuredValue
      alias displayLabel display_label
      deprecation_deprecate :displayLabel
      alias valueLanguage value_language
      deprecation_deprecate :valueLanguage
    end
  end
end
