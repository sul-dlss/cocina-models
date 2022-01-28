# frozen_string_literal: true

module Cocina
  module Models
    class RequestDROStructural < Struct
      attribute :contains, Types::Strict::Array.of(RequestFileSet).default([].freeze)
      attribute :has_member_orders, Types::Strict::Array.of(Sequence).default([].freeze)
      attribute :is_member_of, Types::Strict::Array.of(Druid).default([].freeze)

      alias hasMemberOrders has_member_orders
      deprecation_deprecate :hasMemberOrders
      alias isMemberOf is_member_of
      deprecation_deprecate :isMemberOf
    end
  end
end
