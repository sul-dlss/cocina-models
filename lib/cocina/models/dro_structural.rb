# frozen_string_literal: true

module Cocina
  module Models
    class DROStructural < Struct
      attribute :contains, Types::Strict::Array.of(FileSet).default([].freeze)
      attribute :hasMemberOrders, Types::Strict::Array.of(Sequence).default([].freeze)
      attribute :isMemberOf, Types::Strict::Array.of(Druid).default([].freeze)
      # Agreement that covers the deposit of the DRO into SDR.
      attribute :hasAgreement, Types::Strict::String.meta(omittable: true)
    end
  end
end
