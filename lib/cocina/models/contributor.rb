# frozen_string_literal: true

module Cocina
  module Models
    # Property model for describing agents contributing in some way to the creation and
    # history of the resource.
    class Contributor < BaseModel
      attr_accessor :name, :type, :status, :role, :identifier, :affiliation, :note, :valueAt, :parallelContributor
    end
  end
end
