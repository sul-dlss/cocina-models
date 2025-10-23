# frozen_string_literal: true

module Cocina
  module Models
    # BCP 47 language tag: https://www.rfc-editor.org/rfc/rfc4646.txt -- other applications (like media players) expect language codes of this format, see e.g. https://videojs.com/guides/text-tracks/#srclang
    LanguageTag = Types::String
  end
end
