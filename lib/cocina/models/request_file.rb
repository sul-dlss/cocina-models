# frozen_string_literal: true

module Cocina
  module Models
    class RequestFile < BaseModel
      attr_accessor :type, :label, :filename, :size, :version, :hasMimeType, :languageTag, :externalIdentifier, :use, :sdrGeneratedText, :correctedForAccessibility, :hasMessageDigests, :access, :administrative, :presentation

      TYPES = [
        'https://cocina.sul.stanford.edu/models/file'
      ].freeze
    end
  end
end
