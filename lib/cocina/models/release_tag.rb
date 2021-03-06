# frozen_string_literal: true

module Cocina
  module Models
    class ReleaseTag < Struct
      # Who did this release
      # example: petucket
      attribute :who, Types::Strict::String.meta(omittable: true)
      # What is being released. This item or the whole collection.
      # example: self
      attribute :what, Types::Strict::String.enum('self', 'collection').meta(omittable: true)
      # When did this action happen
      attribute :date, Types::Params::DateTime.meta(omittable: true)
      # What platform is it released to
      # example: Searchworks
      attribute :to, Types::Strict::String.meta(omittable: true)
      attribute :release, Types::Strict::Bool.default(false)
    end
  end
end
