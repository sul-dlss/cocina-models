# frozen_string_literal: true

module Cocina
  module Models
    class ReleaseTag < Struct
      # example: petucket
      attribute :who, Types::Strict::String.meta(omittable: true)
      # example: self
      attribute :what, Types::Strict::String.enum('self', 'collection').meta(omittable: true)
      attribute :date, Types::Params::DateTime.meta(omittable: true)
      # example: Searchworks
      attribute :to, Types::Strict::String.meta(omittable: true)
      attribute :release, Types::Strict::Bool.default(false)
    end
  end
end
