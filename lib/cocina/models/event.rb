# frozen_string_literal: true

module Cocina
  module Models
    class Event < Struct
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveValue).default([])
      # Description of the event (creation, publication, etc.).
      attribute :type, Types::Strict::String.meta(omittable: true)
      # The preferred display label to use for the event in access systems.
      attribute :displayLabel, Types::Strict::String.meta(omittable: true)
      attribute :date, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :contributor, Types::Strict::Array.of(Contributor).default([])
      attribute :location, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :valueLanguage, DescriptiveValueLanguage.optional.meta(omittable: true)
      attribute :parallelEvent, Types::Strict::Array.of(DescriptiveParallelEvent).default([])
    end
  end
end
