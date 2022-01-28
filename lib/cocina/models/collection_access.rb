# frozen_string_literal: true

module Cocina
  module Models
    class CollectionAccess < Struct
      # Access level
      attribute :view, Types::Strict::String.default('dark').enum('world', 'dark').meta(omittable: true)
      # The human readable copyright statement that applies
      # example: Copyright World Trade Organization
      attribute :copyright, Types::Strict::String.optional.meta(omittable: true)
      # The human readable use and reproduction statement that applies
      # example: Property rights reside with the repository. Literary rights reside with the creators of the documents or their heirs. To obtain permission to publish or reproduce, please contact the Public Services Librarian of the Dept. of Special Collections (http://library.stanford.edu/spc).
      attribute :use_and_reproduction_statement, Types::Strict::String.optional.meta(omittable: true)
      # The license governing reuse of the Collection. Should be an IRI for known licenses (i.e. CC, RightsStatement.org URI, etc.).
      attribute :license, Types::Strict::String.optional.meta(omittable: true)

      def method_missing(method_name, *arguments, &block)
        if [:useAndReproductionStatement].include?(method_name)
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
        [:useAndReproductionStatement].include?(method_name) || super
      end
    end
  end
end
