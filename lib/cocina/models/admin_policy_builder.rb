# frozen_string_literal: true

module Cocina
  module Models
    # This creates an AdminPolicy or a RequestAdminPolicy from dynamic attributes
    class AdminPolicyBuilder
      # @return [AdminPolicy,RequestAdminPolicy]
      def self.build(klass, dyn)
        params = {
          type: dyn['type'],
          label: dyn['label'],
          version: dyn['version']
        }
        params[:externalIdentifier] = dyn['externalIdentifier'] if needs_id?(klass)

        # params[:access] = Access.from_dynamic(dyn['access']) if dyn['access']
        if dyn['administrative']
          params[:administrative] = AdminPolicy::Administrative
                                    .from_dynamic(dyn['administrative'])
        end
        params[:description] = Description.from_dynamic(dyn.fetch('description'))
        klass.new(params)
      end

      def self.needs_id?(klass)
        klass.attribute_names.include?(:externalIdentifier)
      end
    end
  end
end
