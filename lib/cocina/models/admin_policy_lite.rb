# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicyLite < BaseModel
      attr_accessor :cocinaVersion, :type, :externalIdentifier, :label, :version, :administrative, :description

      TYPES = [
        'https://cocina.sul.stanford.edu/models/admin_policy'
      ].freeze
    end
  end
end
