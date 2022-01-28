# frozen_string_literal: true

module Cocina
  module Models
    class Event < Struct
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
      attribute :parallel_event, Types::Strict::Array.of(DescriptiveParallelEvent).default([].freeze)

      alias structuredValue structured_value
      deprecation_deprecate :structuredValue
      alias displayLabel display_label
      deprecation_deprecate :displayLabel
      alias valueLanguage value_language
      deprecation_deprecate :valueLanguage
      alias parallelEvent parallel_event
      deprecation_deprecate :parallelEvent
    end
  end
end
