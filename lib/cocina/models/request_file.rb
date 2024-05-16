# frozen_string_literal: true

module Cocina
  module Models
    class RequestFile < Struct
      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/file'].freeze

      attribute :type, Types::Strict::String.enum(*RequestFile::TYPES)
      attribute :label, Types::Strict::String
      attribute :filename, Types::Strict::String
      attribute? :size, Types::Strict::Integer
      attribute :version, Types::Strict::Integer
      attribute? :hasMimeType, Types::Strict::String
      # BCP 47 language tag: https://www.rfc-editor.org/rfc/rfc4646.txt -- other applications (like media players) expect language codes of this format, see e.g. https://videojs.com/guides/text-tracks/#srclang
      attribute? :languageTag, LanguageTag.optional
      attribute? :externalIdentifier, Types::Strict::String
      # Use for the File (e.g. "transcription" for OCR).
      attribute? :use, FileUse.optional
      # Indicates if the text (OCR/captioning) was generated by SDR.
      attribute? :sdrGeneratedText, Types::Strict::Bool.default(false)
      # Indicates if text that has been verified for accessibility/correctness.
      attribute? :correctedForAccessibility, Types::Strict::Bool.default(false)
      attribute :hasMessageDigests, Types::Strict::Array.of(MessageDigest).default([].freeze)
      attribute(:access, FileAccess.default { FileAccess.new })
      attribute(:administrative, FileAdministrative.default { FileAdministrative.new })
      attribute? :presentation, Presentation.optional
    end
  end
end
