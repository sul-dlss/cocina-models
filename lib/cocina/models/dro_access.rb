# frozen_string_literal: true

module Cocina
  module Models
    class DROAccess < BaseModel
      attr_accessor :copyright, :embargo, :useAndReproductionStatement, :license
    end
  end
end
