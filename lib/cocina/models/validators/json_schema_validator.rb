# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates Cocina model instances against the JSON schema.
      #
      # The schema uses OpenAPI 3.1.0 conventions with `unevaluatedProperties: false` to enforce
      # strict validation. However, when schemas use `allOf` with `$ref` (which is common for
      # composing mixins), json_schemer reports cascaded unevaluatedProperties errors that are
      # not actionable.
      #
      # For example, if a schema has:
      #   AdminPolicy:
      #     allOf:
      #       - $ref: '#/$defs/AdminPolicyMixin'   # defines properties
      #     unevaluatedProperties: false
      #
      # And an unexpected property appears at `/administrative/releaseTags`, json_schemer will
      # report both:
      #   - The actual error at `/administrative/releaseTags` (actionable)
      #   - Cascaded errors for every known root property like `/label`, `/type` (noise)
      #
      # This happens because `unevaluatedProperties` semantics with `allOf`/$ref can be
      # ambiguous. See https://github.com/davishmcclurg/json_schemer/issues/157
      #
      # To reduce noise while preserving actionable errors, this validator applies de-noising
      # by keeping only:
      #
      #   1. All errors for nested properties (depth > 1)
      #   2. Root-level errors for genuinely unknown properties (not in the model schema)
      #
      # This filters out cascaded root-level false positives without hiding real nested issues.
      class JsonSchemaValidator
        SCHEMA_PATH = ::File.expand_path('../../../../schema.json', __dir__)

        # @see #validate
        def self.validate(...)
          new(...).validate
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
        # unevaluatedProperties errors before raising a ValidationError.
        #
        # @return [NilClass] returns nil if validation passes
        # @raise [ValidationError] if validation fails, with a de-noised error message
        def validate
          attributes['cocinaVersion'] = Cocina::Models::VERSION if clazz.attribute_names.include?(:cocinaVersion)

          errors = schema.ref("#/$defs/#{method_name}").validate(attributes.as_json).to_a
          return if errors.empty?

          raise ValidationError, "When validating #{method_name}: " + filtered_error_messages(errors).join(', ')
        end

        private

        attr_reader :clazz, :attributes

        # @return [JSONSchemer::Schema]
        def schema
          @schema ||= JSONSchemer.schema(self.class.document)
        end

        # @return [String] the method name derived from the class name
        def method_name
          @method_name ||= clazz.name.split('::').last
        end

        # @return [Array<String>] list of known root property names for the model class
        def known_root_properties
          @known_root_properties ||= clazz.attribute_names.map(&:to_s)
        end

        # Filters and de-duplicates error messages.
        #
        # Applies unevaluatedProperties de-noising to reduce cascaded false-positive errors,
        # then extracts the error message strings and removes duplicates.
        #
        # @param errors [Array<Hash>] errors returned by json_schemer validator
        # @return [Array<String>] de-noised, unique error message strings
        def filtered_error_messages(errors)
          denoised_errors = filter_unevaluated_property_noise(errors)
          denoised_errors.map { |error| error['error'] }.uniq
        end

        # Filters out cascaded unevaluatedProperties errors while preserving actionable ones.
        #
        # When unevaluatedProperties errors are present, this method keeps:
        #   - All non-unevaluatedProperties errors (unchanged)
        #   - All unevaluatedProperties errors for nested properties (depth > 1)
        #   - Root-level unevaluatedProperties errors for genuinely unknown properties
        #
        # It discards:
        #   - Root-level unevaluatedProperties errors for known model attributes
        #
        # This filtering leverages the class attribute schema to distinguish between
        # cascaded noise (root-level disallowed errors for known properties) and genuine
        # issues (unexpected properties at any depth).
        #
        # @param errors [Array<Hash>] errors from json_schemer validator
        # @return [Array<Hash>] filtered error hashes
        def filter_unevaluated_property_noise(errors)
          unevaluated_errors = errors.select { |error| unevaluated_property_error?(error) }
          return errors if unevaluated_errors.empty?

          # Keep non-unevaluated errors and filtered unevaluated errors
          non_unevaluated = errors.reject { |error| unevaluated_property_error?(error) }
          filtered_unevaluated = unevaluated_errors.select do |error|
            depth = pointer_depth(error['data_pointer'])
            # Keep if: no depth data, nested path, or unknown root property
            depth.nil? || depth > 1 || root_unknown_property_error?(error)
          end
          non_unevaluated + filtered_unevaluated
        end

        # Checks if an error represents an unknown property at the root level.
        #
        # A root-level error is actionable only if the property name is not in the model's
        # defined attributes. This distinguishes between genuine unexpected properties and
        # cascaded noise from allOf/$ref evaluation.
        #
        # @param error [Hash] json_schemer error hash
        # @return [Boolean] true if error is for a root-level unknown property
        def root_unknown_property_error?(error)
          return false unless pointer_depth(error['data_pointer']) == 1

          property_name = error['data_pointer'].split('/').last
          !known_root_properties.include?(property_name)
        end

        # Identifies errors related to unevaluatedProperties violations.
        #
        # @param error [Hash] json_schemer error hash
        # @return [Boolean] true if error is an unevaluatedProperties violation
        def unevaluated_property_error?(error)
          error['schema_pointer']&.end_with?('/unevaluatedProperties') ||
            error['error']&.include?('disallowed unevaluated property')
        end

        # Calculates the depth of a JSON pointer path.
        #
        # A root-level property has depth 1 (e.g., `/label`), a nested property has depth > 1
        # (e.g., `/administrative/releaseTags` has depth 2).
        #
        # @param pointer [String, nil] JSON pointer path (e.g., `/administrative/releaseTags`)
        # @return [Integer, nil] path depth, or nil if pointer is nil
        def pointer_depth(pointer)
          return if pointer.nil?
          return 0 if pointer.empty?

          pointer.split('/').reject(&:empty?).length
        end
      end
    end
  end
end
