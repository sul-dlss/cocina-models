# frozen_string_literal: true

module Cocina
  module Models
    # Binaries that are the basis of what our domain manages. Binaries here do not include
    # metadata files generated for the domain's own management purposes.
    class File < BaseModel
      attr_accessor :type, :externalIdentifier, :label, :filename, :size, :version, :hasMimeType, :languageTag, :use, :sdrGeneratedText, :correctedForAccessibility, :hasMessageDigests, :access, :administrative, :presentation

      TYPES = [
        'https://cocina.sul.stanford.edu/models/file'
      ].freeze
    end
  end
end
