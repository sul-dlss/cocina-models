# frozen_string_literal: true

module Cocina
  module Models
    # A request to create an AdminPolicy object.
    # This is the same as an AdminPolicy, but without externalIdentifier (as that wouldn't have been created yet).
    class RequestAdminPolicy < Struct
      include AdminPolicyAttributes

      def self.from_dynamic(dyn)
        RequestAdminPolicy.new(dyn)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
