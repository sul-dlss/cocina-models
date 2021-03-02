# frozen_string_literal: true

module Cocina
  module Models
    class AccessRole < Struct
      # Name of role
      attribute :name, Types::Strict::String.enum('sdr-administrator', 'sdr-viewer', 'dor-apo-manager', 'hydrus-collection-creator', 'hydrus-collection-manager', 'hydrus-collection-depositor', 'hydrus-collection-item-depositor', 'hydrus-collection-reviewer', 'hydrus-collection-viewer')
      attribute :members, Types::Strict::Array.of(AccessRoleMember).default([].freeze)
    end
  end
end
