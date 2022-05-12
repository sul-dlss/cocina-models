# frozen_string_literal: true

module Cocina
  module Models
    # DEPRECATED
    # Value model for multiple representations of information about the same contributor (e.g. in different languages).
    class DescriptiveParallelContributor < Struct
      attribute :name, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Entity type of the contributor (person, organization, etc.). See https://github.com/sul-dlss/cocina-models/blob/main/docs/description_types.md for valid types.
      attribute? :type, Types::Strict::String
      # Status of the contributor relative to other parallel contributors (e.g. the primary author among a group of contributors).
      attribute? :status, Types::Strict::String
      attribute :role, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # URL or other pointer to the location of the contributor information.
      attribute? :valueAt, Types::Strict::String
      attribute? :valueLanguage, DescriptiveValueLanguage.optional
    end
  end
end
