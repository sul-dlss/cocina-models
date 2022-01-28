# frozen_string_literal: true

module Cocina
  module Models
    class RequestDROStructural < Struct
      attribute :contains, Types::Strict::Array.of(RequestFileSet).default([].freeze)
      attribute :has_member_orders, Types::Strict::Array.of(Sequence).default([].freeze)
      attribute :is_member_of, Types::Strict::Array.of(Druid).default([].freeze)
    end
  end
end
