# frozen_string_literal: true

# Collects every validation error for a single Cocina object, instead of stopping at the first.
#
# `Cocina::Models.build` deliberately short-circuits, in three separate places:
#
#   1. `Validators::Validator` runs its validators in sequence; the first one to raise aborts the rest.
#   2. `CompositeDescriptionValidator` / `CompositeStructuralValidator` walk the object once to feed all of
#      their sub-validators, then call `validate!` on each in turn. Every sub-validator has therefore
#      already accumulated its findings, but only the first one to raise is surfaced.
#   3. Validation happens in two passes -- once for the object itself and again for its nested
#      `Description` -- and a failure in the first pass aborts construction before the second ever runs.
#      That means an object failing a top-level validation never has its description validated at all.
#
# This class works around all three from the outside, by invoking one validator at a time: with a single
# validator in the list there is nothing left for a raise to mask. It relies only on the public
# `validators:` keyword that `Validators::Validator.validate` and the composite validators already accept,
# so it requires no changes to the gem.
#
# This is reporting/remediation tooling for bin/validate-data, not part of the gem's public API. Because it
# re-walks the description tree once per sub-validator it is several times slower than a plain
# `Cocina::Models.build`, so callers should use it only for objects already known to be invalid.
class ValidationErrorCollector
  # The gem's validation entry point; it accepts a `validators:` list.
  VALIDATOR = Cocina::Models::Validators::Validator
  SCHEMA_VALIDATOR = Cocina::Models::Validators::JsonSchemaValidator
  SEMANTIC_VALIDATORS = (VALIDATOR::VALIDATORS - [SCHEMA_VALIDATOR]).freeze
  # Composite validators get expanded so that every sub-validator's `validate!` is reached.
  COMPOSITE_SUB_VALIDATORS = {
    Cocina::Models::Validators::CompositeDescriptionValidator =>
      Cocina::Models::Validators::CompositeDescriptionValidator::VALIDATORS,
    Cocina::Models::Validators::CompositeStructuralValidator =>
      Cocina::Models::Validators::CompositeStructuralValidator::VALIDATORS
  }.freeze

  # @param json [Hash] a parsed Cocina JSON serialization
  # @return [Array<String>] every validation error found; empty if the object is valid
  def self.call(json)
    new(json).call
  end

  def initialize(json)
    @json = json
    @hash = json.with_indifferent_access
    @clazz = resolve_clazz
  end

  # @return [Array<String>] every validation error found; empty if the object is valid
  def call
    return [type_error] unless clazz

    # The schema is authoritative for the shape of the object. When it fails, the semantic validators are
    # running against data they cannot make sense of, so anything they report is either noise (a
    # NoMethodError on nil) or a restatement of the schema error. The schema validator already aggregates
    # and de-noises all schema violations into one message, so nothing is lost by stopping here.
    schema_error = capture { SCHEMA_VALIDATOR.validate(clazz, hash) }
    return [schema_error] if schema_error

    semantic_errors + construction_errors
  end

  private

  attr_reader :json, :hash, :clazz

  # Runs both validation passes: the object itself, then its nested description.
  def semantic_errors
    errors = pass_errors(clazz, hash)
    return errors unless hash[:description].is_a?(Hash)

    errors + pass_errors(Cocina::Models::Description, hash[:description])
  end

  # @return [Array<String>] errors from running each validator against the given class in isolation
  def pass_errors(pass_clazz, attributes)
    SEMANTIC_VALIDATORS.flat_map do |validator|
      sub_validators = COMPOSITE_SUB_VALIDATORS[validator]
      if sub_validators
        composite_errors(validator, sub_validators, pass_clazz, attributes)
      else
        Array(capture { VALIDATOR.validate(pass_clazz, attributes, validators: [validator]) })
      end
    end
  end

  # Runs a composite validator once per sub-validator, so that no sub-validator can mask another.
  def composite_errors(composite, sub_validators, pass_clazz, attributes)
    sub_validators.filter_map do |sub_validator|
      capture { composite.new(pass_clazz, attributes, validators: [sub_validator]).validate }
    end
  end

  # Type coercion errors that the JSON schema did not catch.
  def construction_errors
    Cocina::Models.build(json, validate: false)
    []
  rescue StandardError => e
    ["#{e.class}: #{e.message}"]
  end

  # @return [String, nil] the error message, or nil if the block did not raise
  def capture
    yield
    nil
  rescue Cocina::Models::ValidationError => e
    e.message
  rescue StandardError => e
    "#{e.class}: #{e.message}"
  end

  def type_error
    return 'Cocina::Models::ValidationError: Type field not found' if hash[:type].blank?

    "Cocina::Models::UnknownTypeError: Unknown type: '#{hash[:type]}'"
  end

  # Mirrors the class dispatch in `Cocina::Models.build`, whose `type_for` and `has_metadata?` are private.
  # Kept honest by a spec that compares this against the class `Cocina::Models.build` actually returns.
  def resolve_clazz
    case hash[:type]
    when *Cocina::Models::DRO::TYPES
      with_metadata? ? Cocina::Models::DROWithMetadata : Cocina::Models::DRO
    when *Cocina::Models::Collection::TYPES
      with_metadata? ? Cocina::Models::CollectionWithMetadata : Cocina::Models::Collection
    when *Cocina::Models::AdminPolicy::TYPES
      with_metadata? ? Cocina::Models::AdminPolicyWithMetadata : Cocina::Models::AdminPolicy
    end
  end

  def with_metadata?
    Cocina::Models::METADATA_KEYS.any? { |key| hash.key?(key) }
  end
end
