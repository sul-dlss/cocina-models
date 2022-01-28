# frozen_string_literal: true

module Cocina
  module Models
    class FileAdministrative < Struct
      attribute :publish, Types::Strict::Bool.default(false)
      attribute :sdr_preserve, Types::Strict::Bool.default(true)
      attribute :shelve, Types::Strict::Bool.default(false)

      def method_missing(method_name, *arguments, &block)
        if [:sdrPreserve].include?(method_name)
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
        [:sdrPreserve].include?(method_name) || super
      end
    end
  end
end
