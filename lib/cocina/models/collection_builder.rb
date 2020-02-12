# frozen_string_literal: true

module Cocina
  module Models
    # This creates a Collection or a RequestCollection from dynamic attributes
    class CollectionBuilder
      # @return [Collection,RequestCollection]
      # rubocop:disable Metrics/MethodLength
      def self.build(klass, dyn)
        params = {
          type: dyn['type'],
          label: dyn['label'],
          version: dyn['version'],
          description: Description.from_dynamic(dyn.fetch('description'))
        }
        params[:externalIdentifier] = dyn['externalIdentifier'] if needs_id?(klass)
        # params[:access] = Access.from_dynamic(dyn['access']) if dyn['access']
        if dyn['administrative']
          params[:administrative] = Collection::Administrative
                                    .from_dynamic(dyn['administrative'])
        end
        if dyn['identification']
          params[:identification] = Collection::Identification
                                    .from_dynamic(dyn['identification'])
        end
        klass.new(params)
      end
      # rubocop:enable Metrics/MethodLength

      def self.needs_id?(klass)
        klass.attribute_names.include?(:externalIdentifier)
      end
    end
  end
end
