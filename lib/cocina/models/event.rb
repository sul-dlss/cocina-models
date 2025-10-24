# frozen_string_literal: true

module Cocina
  module Models
    # Property model for describing events in the history of the resource.
    class Event < Struct
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Description of the event (creation, publication, etc.).
      attribute? :type, Types::Strict::String
      # The preferred display label to use for the event in access systems.
      attribute? :displayLabel, Types::Strict::String
      # Dates associated with the event.
      attribute :date, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Contributors associated with the event.
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      # Locations associated with the event.
      attribute :location, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Identifiers and URIs associated with the event.
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Other information about the event.
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Language of the descriptive element value
      attribute? :valueLanguage, DescriptiveValueLanguage.optional
      # For multiple representations of information about the same event (e.g. in different
      # languages)
      attribute :parallelEvent, Types::Strict::Array.of(DescriptiveParallelEvent).default([].freeze)
    end
  end
end
