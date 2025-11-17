# frozen_string_literal: true

module Cocina
  module Models
    # Basic value model for descriptive elements. Can only have one of value, parallelValue,
    # groupedValue, or structuredValue.
    class DescriptiveBasicValue < BaseModel
      attr_accessor :structuredValue, :parallelValue, :groupedValue, :value, :type, :status, :code, :uri, :standard, :encoding, :identifier, :source, :displayLabel, :qualifier, :note, :valueLanguage, :valueAt
    end
  end
end
