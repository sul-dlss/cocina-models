# frozen_string_literal: true

module Cocina
  module Models
    # Provides the template of access settings that is copied to the items governed by
    # an AdminPolicy. This is almost the same as DROAccess, but it provides no defaults
    # and has no embargo.
    class AdminPolicyAccessTemplate < BaseModel
      attr_accessor :copyright, :useAndReproductionStatement, :license, :view, :download, :location, :controlledDigitalLending
    end
  end
end
