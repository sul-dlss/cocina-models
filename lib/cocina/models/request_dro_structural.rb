# frozen_string_literal: true

module Cocina
  module Models
    class RequestDROStructural < Struct
      attribute :contains, Types::Strict::Array.of(RequestFileSet).default([])
      attribute :hasMemberOrders, Types::Strict::Array.of(Sequence).default([])
      attribute :isMemberOf, Types::Strict::Array.of(Druid).default([])
      attribute :hasAgreement, Types::Strict::String.meta(omittable: true)
    end
  end
end
