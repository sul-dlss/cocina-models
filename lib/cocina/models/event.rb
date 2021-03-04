# frozen_string_literal: true

module Cocina
  module Models
    class Event < Struct
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
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
      attribute :valueScript, Standard.optional.meta(omittable: true)
      # Description of the event (creation, publication, etc.).
      attribute :type, Types::Strict::String.meta(omittable: true)
      # The preferred display label to use for the event in access systems.
      attribute :displayLabel, Types::Strict::String.meta(omittable: true)
      attribute :date, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :contributor, Types::Strict::Array.of(Contributor).meta(omittable: true)
      attribute :location, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :parallelEvent, Types::Strict::Array.of(DescriptiveParallelEvent).meta(omittable: true)
    end
  end
end
