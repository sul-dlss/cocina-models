# frozen_string_literal: true

module Cocina
  module Models
    class Contributor < Struct
      attribute :name, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      # Entity type of the contributor (person, organization, etc.).
      attribute :type, Types::Strict::String.meta(omittable: true)
      # Status of the contributor relative to other parallel contributors.
      attribute :status, Types::Strict::String.meta(omittable: true)
      attribute :role, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
    end
  end
end
