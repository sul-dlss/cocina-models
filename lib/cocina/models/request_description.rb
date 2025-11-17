# frozen_string_literal: true

module Cocina
  module Models
    # Description that is included in a request to create a DRO. This is the same as a
    # Description, except excludes PURL.
    class RequestDescription < BaseModel
      attr_accessor :title, :contributor, :event, :form, :geographic, :language, :note, :identifier, :subject, :access, :relatedResource, :marcEncodedData, :adminMetadata, :valueAt

      include Validatable
    end
  end
end
