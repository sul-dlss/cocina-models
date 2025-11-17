# frozen_string_literal: true

module Cocina
  module Models
    class Description < BaseModel
      attr_accessor :title, :contributor, :event, :form, :geographic, :language, :note, :identifier, :subject, :access, :relatedResource, :marcEncodedData, :adminMetadata, :valueAt, :purl

      include Validatable
    end
  end
end
