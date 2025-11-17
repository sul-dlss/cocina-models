# frozen_string_literal: true

module Cocina
  module Models
    # Property model for describing events in the history of the resource.
    class Event < BaseModel
      attr_accessor :structuredValue, :type, :displayLabel, :date, :contributor, :location, :identifier, :note, :valueLanguage, :parallelEvent
    end
  end
end
