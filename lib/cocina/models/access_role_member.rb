# frozen_string_literal: true

module Cocina
  module Models
    # Represents a user or group that is a member of an AccessRole
    class AccessRoleMember < BaseModel
      attr_accessor :type, :identifier

      TYPES = %w[
        sunetid
        workgroup
      ].freeze
    end
  end
end
