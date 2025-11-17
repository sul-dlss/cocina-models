# frozen_string_literal: true

module Cocina
  module Models
    # Value model for multiple representations of information about the same event (e.g.
    # in different languages).
    class DescriptiveParallelEvent < BaseModel
      attr_accessor :structuredValue, :type, :displayLabel, :date, :contributor, :location, :identifier, :note, :valueLanguage
    end
  end
end
