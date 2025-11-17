# frozen_string_literal: true

module Cocina
  module Models
    # DEPRECATED
    # Value model for multiple representations of information about the same contributor
    # (e.g. in different languages).
    class DescriptiveParallelContributor < BaseModel
      attr_accessor :name, :type, :status, :role, :identifier, :note, :valueAt, :valueLanguage
    end
  end
end
