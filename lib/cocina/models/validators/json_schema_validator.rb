# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates Cocina model instances against the JSON schema.
      #
      # The schema uses OpenAPI 3.1.0 conventions with `unevaluatedProperties: false` to enforce
      # strict validation. However, allOf/$ref composition causes two categories of cascade noise
      # in the structured evaluation output that must be filtered before reporting:
      #
      #   1. falseSchema entries — every `unevaluatedProperties: false` sub-schema emits a
      #      "False schema does not allow …" entry for each value at that path. These are always
      #      redundant with the parent unevaluatedProperties entry.
      #
      #   2. Root-level unevaluatedProperties listing only known model attributes as unexpected —
      #      the validator can't prove top-level fields were "evaluated" through allOf/$ref, so it
      #      reports every legitimate root property as unexpected at root "".
      #
      # For example, validating a DRO with an unexpected `releaseTags` in `administrative` produces
      # one actionable error plus ~12 cascade entries. The de-noiser keeps the actionable error
      # and discards the rest.
      class JsonSchemaValidator
        SCHEMA_PATH = ::File.expand_path('../../../../schema.json', __dir__)

        # @see #validate
        def self.validate(...)
          new(...).validate
        end

        # @return [JSONSchema validator] a cached per-definition validator
        def self.validator_for(def_name)
          @validators ||= {}
          @validators[def_name] ||= JSONSchema.validator_for({ '$ref' => "#/$defs/#{def_name}", '$defs' => document['$defs'] })
        end

        # @return [Hash] a hash representation of the schema.json document
        def self.document
          @document ||= begin
            file_content = ::File.read(SCHEMA_PATH)
            JSON.parse(file_content)
          end
        end

        # @param clazz [Class] the Cocina model class being validated (e.g., Cocina::Models::DRO)
        # @param attributes [Hash] the attributes of the model instance being validated
        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
        end

        # Validates attributes against the Cocina model schema.
        #
        # Injects the cocinaVersion if the model includes it as an attribute, then validates
        # the attributes against the schema definition for this model. De-noises
        # unevaluatedProperties cascade errors before raising a ValidationError.
        #
        # Uses the structured evaluation API to capture sub-errors inside anyOf branches,
        # producing actionable messages (e.g. path-qualified minItems/pattern failures)
        # rather than the generic "not valid under anyOf" message.
        #
        # @return [NilClass] returns nil if validation passes
        # @raise [ValidationError] if validation fails, with a de-noised error message
        def validate
          attributes['cocinaVersion'] = Cocina::Models::VERSION if clazz.attribute_names.include?(:cocinaVersion)

          evaluation = self.class.validator_for(method_name).evaluate(attributes.as_json)
          return if evaluation.valid?

          raise ValidationError, "When validating #{method_name}: " + filtered_error_messages(evaluation).join(', ')
        end

        private

        attr_reader :clazz, :attributes

        # @return [String] the method name derived from the class name
        def method_name
          @method_name ||= clazz.name.split('::').last
        end

        # @return [Array<String>] list of known root property names for the model class
        def known_root_properties
          @known_root_properties ||= clazz.attribute_names.map(&:to_s)
        end

        def filtered_error_messages(evaluation)
          details = evaluation.list[:details].select { |d| !d[:valid] && d[:errors] }
          denoised = denoise(details)
          denoised.flat_map { |d| format_detail(d) }.uniq
        end

        # Removes two categories of cascade noise produced by `unevaluatedProperties: false`:
        #
        #   1. falseSchema errors — every `unevaluatedProperties: false` on a sub-path emits
        #      a "False schema does not allow …" entry for each matched value.  These are
        #      always redundant with the parent unevaluatedProperties entry.
        #
        #   2. Root-level unevaluatedProperties errors where every listed unexpected property
        #      is a known model attribute — these arise because allOf/$ref composition means
        #      the validator can't prove top-level properties were "evaluated", even though
        #      they are valid model fields.
        def denoise(details)
          details.reject { |d| false_schema_noise?(d) || root_unevaluated_noise?(d) }
        end

        def false_schema_noise?(detail)
          detail[:errors].key?('falseSchema')
        end

        def root_unevaluated_noise?(detail)
          return false unless detail[:errors].key?('unevaluatedProperties')
          return false unless detail[:instanceLocation].empty?

          msg = detail[:errors]['unevaluatedProperties']
          match = msg.match(/\('(.+)' (?:was|were) unexpected\)/)
          return false unless match

          unexpected = match[1].split(', ').map { |p| p.strip.delete("'") }
          unexpected.all? { |prop| known_root_properties.include?(prop) }
        end

        def format_detail(detail)
          loc = detail[:instanceLocation]
          detail[:errors].map do |_keyword, message|
            loc.empty? ? message : "#{message} at #{loc}"
          end
        end
      end
    end
  end
end
