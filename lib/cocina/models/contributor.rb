# frozen_string_literal: true

module Cocina
  module Models
    class Contributor < Struct
      attribute :name, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Entity type of the contributor (person, organization, etc.). See https://sul-dlss.github.io/cocina-models/description_types.html for valid types.
      attribute? :type, Types::Strict::String
      # Status of the contributor relative to other parallel contributors (e.g. the primary author among a group of contributors).
      attribute? :status, Types::Strict::String
      attribute :role, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # URL or other pointer to the location of the contributor information.
      attribute? :value_at, Types::Strict::String
      attribute :parallel_contributor, Types::Strict::Array.of(DescriptiveParallelContributor).default([].freeze)

      alias valueAt value_at
      deprecation_deprecate :valueAt
      alias parallelContributor parallel_contributor
      deprecation_deprecate :parallelContributor
    end
  end
end
