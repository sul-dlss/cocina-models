# frozen_string_literal: true

module Cocina
  module Models
    # Language of the descriptive element value
    class DescriptiveValueLanguage < BaseModel
      attr_accessor :code, :uri, :value, :note, :version, :source, :valueScript
    end
  end
end
