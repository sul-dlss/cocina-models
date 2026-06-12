# frozen_string_literal: true

require 'cocina_display'

module Cocina
  module Models
    module Validators
      # Validates that contributor role codes from the marcrelator vocabulary are valid MARC relator codes.
      # Includes discontinued codes. See https://www.loc.gov/marc/relators/relacode.html
      class MarcRelatorRoleValidator
        MARCRELATOR_SOURCE_CODES = %w[marcrelator].freeze
        MARCRELATOR_SOURCE_URI = 'http://id.loc.gov/vocabulary/relators/'

        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
          @errors = []
        end

        def validate
          return unless meets_preconditions?

          resources.each { |resource| validate_resource(resource) }
          raise ValidationError, "Invalid MARC relator codes in description: #{@errors.join(', ')}" if @errors.any?
        end

        private

        attr_reader :clazz, :attributes

        def meets_preconditions?
          [Cocina::Models::Description, Cocina::Models::RequestDescription].include?(clazz)
        end

        def resources
          [description_attributes] + Array(description_attributes[:relatedResource])
        end

        def description_attributes
          @description_attributes ||= if [Cocina::Models::Description,
                                          Cocina::Models::RequestDescription].include?(clazz)
                                        attributes
                                      else
                                        attributes[:description] || {}
                                      end
        end

        def validate_resource(resource)
          Array(resource[:contributor]).each_with_index do |contributor, contributor_index|
            Array(contributor[:role]).each_with_index do |role, role_index|
              validate_role(role, "contributor#{contributor_index + 1}.role#{role_index + 1}")
            end
          end
        end

        def validate_role(role, path)
          return unless marc_relator_source?(role)

          code = role[:code]
          return if code.nil?

          @errors << "#{path} (#{code})" unless valid_codes.include?(code)
        end

        def marc_relator_source?(role)
          source = role[:source] || {}
          MARCRELATOR_SOURCE_CODES.include?(source[:code]) ||
            source[:uri]&.start_with?(MARCRELATOR_SOURCE_URI)
        end

        # rubocop:disable Style/ClassVars
        def valid_codes
          @@valid_codes ||= YAML.load_file(CocinaDisplay.root.join('config/marc_relators.yml')).keys
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
