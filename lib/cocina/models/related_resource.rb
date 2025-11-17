# frozen_string_literal: true

module Cocina
  module Models
    # Other resource associated with the described resource.
    class RelatedResource < BaseModel
      attr_accessor :type, :dataCiteRelationType, :status, :displayLabel, :title, :contributor, :event, :form, :language, :note, :identifier, :standard, :subject, :purl, :access, :relatedResource, :adminMetadata, :version, :valueAt
    end
  end
end
