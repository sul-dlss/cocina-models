# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveParallelEvent < Struct
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Description of the event (creation, publication, etc.).
      attribute :type, Types::Strict::String.meta(omittable: true)
      # The preferred display label to use for the event in access systems.
      attribute :displayLabel, Types::Strict::String.meta(omittable: true)
      attribute :date, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      attribute :location, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :valueLanguage, DescriptiveValueLanguage.optional.meta(omittable: true)
    end
  end
end
