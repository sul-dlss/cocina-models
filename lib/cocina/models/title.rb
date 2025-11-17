# frozen_string_literal: true

module Cocina
  module Models
    class Title < BaseModel
      attr_accessor :structuredValue, :parallelValue, :groupedValue, :value, :type, :status, :code, :uri, :standard, :encoding, :identifier, :source, :displayLabel, :qualifier, :note, :valueLanguage, :valueAt, :appliesTo
    end
  end
end
