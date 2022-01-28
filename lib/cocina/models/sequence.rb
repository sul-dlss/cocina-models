# frozen_string_literal: true

module Cocina
  module Models
    class Sequence < Struct
      attribute :members, Types::Strict::Array.of(Types::Strict::String).default([].freeze)
      # The direction that a sequence of canvases should be displayed to the user
      attribute :viewing_direction,
                Types::Strict::String.enum('right-to-left', 'left-to-right').meta(omittable: true)

      def method_missing(method_name, *arguments, &block)
        if [:viewingDirection].include?(method_name)
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
        [:viewingDirection].include?(method_name) || super
      end
    end
  end
end
