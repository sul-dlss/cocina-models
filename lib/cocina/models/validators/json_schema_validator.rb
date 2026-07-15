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
          # Skip when nested inside another Validatable's construction: the enclosing object's own
          # schema check already covers this, so re-evaluating it here would be
          # redundant. See Validatable#new.
          return if Thread.current[:cocina_construction_depth].to_i.positive?

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

          raise ValidationError, "When validating #{method_name}: " + filtered_error_messages(evaluation).join('; ')
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

        #  Removes three categories of cascade noise from errors:
        #
        #   1. falseSchema errors — every `unevaluatedProperties: false` on a sub-path emits
        #      a "False schema does not allow …" entry for each matched value.  These are
        #      always redundant with the parent unevaluatedProperties entry.
        #
        #   2. Root-level unevaluatedProperties errors where every listed unexpected property
        #      is a known model attribute — these arise because allOf/$ref composition means
        #      the validator can't prove top-level properties were "evaluated", even though
        #      they are valid model fields.
        #
        #   3. anyOf branch noise — when each branch requires a different property, all failing
        #      branches emit a separate "required" error at the same path. Collapse into one
        #      "needs to include at least one of: …" message.
        def denoise(details)
          filtered = details.reject { |detail| false_schema_noise?(detail) || root_unevaluated_noise?(detail) }
          collapse_anyof_required(filtered)
        end

        def collapse_anyof_required(details)
          # instanceLocation is the input data that failed. Group errors for each failing data location.
          details.group_by { |detail| detail[:instanceLocation] }.flat_map do |loc, group|
            # splits errors into "required" anyOf errors and others (minItems, unevaluatedProperties)
            required, others = group.partition { |detail| detail[:errors].keys == ['required'] }
            next group if required.size <= 1

            # Extract property name from "required" messages such as, '"url" is a required property'
            props = required.filter_map { |detail| detail[:errors]['required'][/"([^"]+)"/, 1] }.uniq
            # Put the data path at the start of the message; blank instanceLocation so format_detail won't also append it
            msg = "#{loc} needs to include at least one of the following: #{props.join(', ')}"
            others + [required.first.merge(instanceLocation: '', errors: { 'required' => msg })]
          end
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

        # Formats error details hash into more user-friendly messages
        # A detail can carry multiple errors (one per JSON Schema keyword), so this returns an array.
        # minItems errors get a dedicated formatter; everything else uses the generic one.
        def format_detail(detail)
          loc = detail[:instanceLocation]
          detail[:errors].map do |keyword, message|
            keyword == 'minItems' ? format_min_items(message, loc) : format_generic(message, loc)
          end
        end

        # Rewrites messages regarding minItems validation
        # "[] has less than 1 item at /event/0/date " is rewritten to "/event/0/date is empty but should have at least 1 item"
        # Arrays with items but fewer than the minimum will be rewritten to "/event/0/date should have at least 2 items"
        def format_min_items(message, loc)
          # extract minimum number of items from message
          min = message[/less than (\d+)/, 1] || '1'
          # pluralize "item" when appropriate
          items = min == '1' ? 'item' : 'items'
          # determine if the message is about an empty array or an non-empty array without enough items
          prefix = message.start_with?('[]') ? "#{loc} is empty but" : loc.to_s
          "#{prefix} should have at least #{min} #{items}"
        end

        def format_generic(message, loc)
          loc.empty? ? message : "#{message} at #{loc}"
        end
      end
    end
  end
end
