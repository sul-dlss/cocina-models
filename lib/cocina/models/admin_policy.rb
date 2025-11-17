# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicy < BaseModel
      attr_accessor :cocinaVersion, :type, :externalIdentifier, :label, :version, :administrative, :description

      include Validatable

      TYPES = [
        'https://cocina.sul.stanford.edu/models/admin_policy'
      ].freeze
    end
  end
end
