# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveGeographicMetadata < Struct
      attribute :form, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
    end
  end
end
