# frozen_string_literal: true

module Cocina
  module Models
    class RequestDROStructural < Struct
      attribute :contains, Types::Strict::Array.of(RequestFileSet).meta(omittable: true)
      attribute :hasMemberOrders, Types::Strict::Array.of(Sequence).meta(omittable: true)
      # example: druid:bc123df4567
      attribute :isMemberOf, Types::Strict::String.meta(omittable: true)
      attribute :hasAgreement, Types::Strict::String.meta(omittable: true)
    end
  end
end
