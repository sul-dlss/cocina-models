# frozen_string_literal: true

module Cocina
  module Models
    # Represents a user or group that is a member of an AccessRole
    class AccessRoleMember < Struct
      include Checkable

      TYPES = %w[sunetid
                 workgroup].freeze

      # Name of role
      attribute :type, Types::Strict::String.enum(*AccessRoleMember::TYPES)
      attribute :identifier, Types::Strict::String
    end
  end
end
