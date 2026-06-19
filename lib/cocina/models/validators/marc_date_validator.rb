# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates MARC date values.
      class MarcDateValidator
        def self.validate(date)
          new(date).validate
        end

        def initialize(date)
          @date = date
        end

        # MARC date formats:
        #   YYYY     — 4 chars; digits may be replaced by 'u' (uncertain) or '|' (no attempt to code)
        #   YYMMDD   — 6 chars; digits or 'u'
        #   YYYYMMDD — 8 chars; digits or 'u'
        def validate # rubocop:disable Naming/PredicateMethod
          /\A[0-9u|]{4}\z/.match?(@date) ||
            /\A[0-9u]{6}\z/.match?(@date) ||
            /\A[0-9u]{8}\z/.match?(@date)
        end
      end
    end
  end
end
