# frozen_string_literal: true

module Cocina
  module Models
    # Information about this resource description.
    class DescriptiveAdminMetadata < BaseModel
      attr_accessor :contributor, :event, :language, :note, :metadataStandard, :identifier
    end
  end
end
