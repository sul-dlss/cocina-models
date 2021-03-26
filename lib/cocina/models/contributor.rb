# frozen_string_literal: true

module Cocina
  module Models
    class Contributor < Struct
      attribute :name, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      # Entity type of the contributor (person, organization, etc.).
      attribute :type, Types::Strict::String.optional.meta(omittable: true)
      # Status of the contributor relative to other parallel contributors (e.g. the primary author among a group of contributors).
      attribute :status, Types::Strict::String.optional.meta(omittable: true)
      attribute :role, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      # URL or other pointer to the location of the contributor information.
      attribute :valueAt, Types::Strict::String.optional.meta(omittable: true)
      attribute :parallelContributor, Types::Strict::Array.of(DescriptiveParallelContributor).meta(omittable: true)
    end
  end
end
