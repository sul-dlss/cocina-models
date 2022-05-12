# frozen_string_literal: true

module Cocina
  module Models
    # Access role conferred by an AdminPolicy to objects within it. (used by Argo)
    class AccessRole < Struct
      # Name of role
      attribute :name, Types::Strict::String.enum('dor-apo-depositor', 'dor-apo-manager', 'dor-apo-viewer', 'sdr-administrator', 'sdr-viewer', 'hydrus-collection-creator', 'hydrus-collection-manager', 'hydrus-collection-depositor', 'hydrus-collection-item-depositor', 'hydrus-collection-reviewer', 'hydrus-collection-viewer')
      attribute :members, Types::Strict::Array.of(AccessRoleMember).default([].freeze)
    end
  end
end
