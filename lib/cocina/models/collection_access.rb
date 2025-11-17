# frozen_string_literal: true

module Cocina
  module Models
    # Access metadata for collections
    class CollectionAccess < BaseModel
      attr_accessor :view, :copyright, :useAndReproductionStatement, :license
    end
  end
end
