# frozen_string_literal: true

module Cocina
  module Models
    # This creates a DRO or a RequestDRO from dynamic attributes
    class DROBuilder
      # @return [DRO,RequestDRO]
      # rubocop:disable Metrics/AbcSize
      def self.build(klass, dyn)
        params = {
          type: dyn['type'],
          label: dyn['label'],
          version: dyn['version'],
          description: Description.from_dynamic(dyn.fetch('description'))
        }
        params[:externalIdentifier] = dyn['externalIdentifier'] if needs_id?(klass)

        params[:access] = DRO::Access.from_dynamic(dyn['access']) if dyn['access']
        params[:administrative] = DRO::Administrative.from_dynamic(dyn['administrative']) if dyn['administrative']
        params[:identification] = DRO::Identification.from_dynamic(dyn['identification']) if dyn['identification']
        params[:structural] = DRO::Structural.from_dynamic(dyn['structural']) if dyn['structural']
        klass.new(params)
      end
      # rubocop:enable Metrics/AbcSize

      def self.needs_id?(klass)
        klass.attribute_names.include?(:externalIdentifier)
      end
    end
  end
end
