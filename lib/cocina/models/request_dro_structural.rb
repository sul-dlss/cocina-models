# frozen_string_literal: true

module Cocina
  module Models
    # Structural metadata
    class RequestDROStructural < Struct
      attribute :contains, Types::Strict::Array.of(RequestFileSet).default([].freeze)
      attribute :hasMemberOrders, Types::Strict::Array.of(Sequence).default([].freeze)
      # Collections that this DRO is a member of
      attribute :isMemberOf, Types::Strict::Array.of(Druid).default([].freeze)
    end
  end
end
