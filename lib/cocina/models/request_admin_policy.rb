# frozen_string_literal: true

module Cocina
  module Models
    # Same as an AdminPolicy, but doesn't have an externalIdentifier as one will be created
    class RequestAdminPolicy < BaseModel
      attr_accessor :cocinaVersion, :type, :label, :version, :administrative, :description

      include Validatable

      TYPES = [
        'https://cocina.sul.stanford.edu/models/admin_policy'
      ].freeze
    end
  end
end
