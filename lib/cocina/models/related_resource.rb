# frozen_string_literal: true

module Cocina
  module Models
    class RelatedResource < Struct
      attribute :type, Types::Strict::String.meta(omittable: true)
      attribute :title, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :contributor, Types::Strict::Array.of(Contributor).meta(omittable: true)
      attribute :event, Types::Strict::Array.of(Event).meta(omittable: true)
      attribute :form, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :language, Types::Strict::Array.of(Language).meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      # Stanford persistent URL associated with the resource.
      attribute :purl, Types::Strict::String.meta(omittable: true)
      attribute :access, DescriptiveAccessMetadata.optional.meta(omittable: true)

      end
    end
  end
end
