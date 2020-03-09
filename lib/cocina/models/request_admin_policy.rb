# frozen_string_literal: true

module Cocina
  module Models
    # A request to create an AdminPolicy object.
    # This is the same as an AdminPolicy, but without externalIdentifier (as that wouldn't have been created yet).
    class RequestAdminPolicy < Struct
      include AdminPolicyAttributes
    end
  end
end
