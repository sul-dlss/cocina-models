# frozen_string_literal: true

module Cocina
  module Models
    # Languages, scripts, symbolic systems, and notations used in all or part of a resource
    # or its descriptive metadata.
    class Language < BaseModel
      attr_accessor :appliesTo, :code, :displayLabel, :encoding, :groupedValue, :note, :parallelValue, :qualifier, :script, :source, :status, :standard, :structuredValue, :uri, :value, :valueAt, :valueLanguage
    end
  end
end
