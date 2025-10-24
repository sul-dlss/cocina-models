# frozen_string_literal: true

module Cocina
  module Models
    # Property model for describing agents contributing in some way to the creation and
    # history of the resource.
    class Contributor < Struct
      # Names associated with a contributor.
      attribute :name, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Entity type of the contributor (person, organization, etc.). See https://github.com/sul-dlss/cocina-models/blob/main/docs/description_types.md
      # for valid types.
      attribute? :type, Types::Strict::String
      # Status of the contributor relative to other parallel contributors (e.g. the primary
      # author among a group of contributors).
      attribute? :status, Types::Strict::String
      # Relationships of the contributor to the resource or to an event in its history.
      attribute :role, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Identifiers and URIs associated with the contributor entity.
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Institutional or other affiliation associated with a contributor.
      attribute :affiliation, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Other information associated with the contributor.
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # URL or other pointer to the location of the contributor information.
      attribute? :valueAt, Types::Strict::String
      # For multiple representations of information about the same contributor (e.g. in different
      # languages).
      attribute :parallelContributor, Types::Strict::Array.of(DescriptiveParallelContributor).default([].freeze)
    end
  end
end
