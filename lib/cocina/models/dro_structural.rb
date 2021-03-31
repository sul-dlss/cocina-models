# frozen_string_literal: true

module Cocina
  module Models
    class DROStructural < Struct
      attribute :contains, Types::Strict::Array.of(FileSet).meta(omittable: true)
      attribute :hasMemberOrders, Types::Strict::Array.of(Sequence).meta(omittable: true)
      attribute :isMemberOf, Types::Strict::Array.of(Druid).meta(omittable: true)
      # Agreement that covers the deposit of the DRO into SDR.
      attribute :hasAgreement, Types::Strict::String.optional.meta(omittable: true)
    end
  end
end
