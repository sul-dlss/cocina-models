# frozen_string_literal: true

module Cocina
  module Models
    class RequestDROStructural < Struct
      attribute :contains, Types::Strict::Array.of(RequestFileSet).default([].freeze)
      attribute :has_member_orders, Types::Strict::Array.of(Sequence).default([].freeze)
      attribute :is_member_of, Types::Strict::Array.of(Druid).default([].freeze)

      def method_missing(method_name, *arguments, &block)
        if %i[hasMemberOrders isMemberOf].include?(method_name)
          Deprecation.warn(
            self,
            "the `#{method_name}` attribute is deprecated and will be removed in the cocina-models 1.0.0 release"
          )
          public_send(method_name.to_s.underscore, *arguments, &block)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        %i[hasMemberOrders isMemberOf].include?(method_name) || super
      end
    end
  end
end
