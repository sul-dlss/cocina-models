# frozen_string_literal: true

module Cocina
  module Models
    # Admin Policy with addition object metadata.
    class AdminPolicyWithMetadata < BaseModel
      attr_accessor :cocinaVersion, :type, :externalIdentifier, :label, :version, :administrative, :description, :created, :modified, :lock

      include Validatable

      TYPES = [
        'https://cocina.sul.stanford.edu/models/admin_policy'
      ].freeze
    end
  end
end
