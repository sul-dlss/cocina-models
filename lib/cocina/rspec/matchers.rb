# frozen_string_literal: true

# Provides RSpec matchers for Cocina models
module Cocina
  module RSpec
    # Cocina-related RSpec matchers
    module Matchers
      extend ::RSpec::Matchers::DSL

      # NOTE: each k/v pair in the hash passed to this matcher will need to be present in actual
      matcher :cocina_object_with do |**kwargs|
        kwargs.each do |cocina_section, expected|
          match do |actual|
            expected.all? do |expected_key, expected_value|
              # NOTE: there's no better method on Hash that I could find for this.
              #        #include? and #member? only check keys, not k/v pairs
              actual.public_send(cocina_section).to_h.any? do |actual_key, actual_value|
                if expected_value.is_a?(Hash) && actual_value.is_a?(Hash)
                  expected_value.all? { |pair| actual_value.to_a.include?(pair) }
                else
                  actual_key == expected_key && actual_value == expected_value
                end
              end
            end
          end
        end
      end

      alias_matcher :match_cocina_object_with, :cocina_object_with

      # The `equal_cocina_model` matcher compares a JSON string as actual value
      # against a Cocina model coerced to JSON as expected value. We want to compare
      # these as JSON rather than as hashes, else we'll have to start
      # deep-converting some values within the hashes, thinking of date/time values
      # in particular. This matching behavior continues what dor-services-app was
      # already doing before this custom matcher was written.
      #
      # Note, though, that when actual and expected values do *not* match, we coerce
      # both values to hashes to allow the `super_diff` gem to highlight the areas
      # that differ. This is easier to scan than two giant JSON strings.
      matcher :equal_cocina_model do |expected|
        match do |actual|
          Cocina::Models.build(JSON.parse(actual)).to_json == expected.to_json
        rescue NoMethodError
          warn "Could not match cocina models because expected is not a valid JSON string: #{expected}"
          false
        end

        failure_message do |actual|
          SuperDiff::EqualityMatchers::Hash.new(
            expected: expected.to_h.deep_symbolize_keys,
            actual: JSON.parse(actual, symbolize_names: true)
          ).fail
        rescue StandardError => e
          "ERROR in CocinaMatchers: #{e}"
        end
      end

      matcher :cocina_object_with_types do |expected|
        match do |actual|
          return false if expected[:without_order] && !match_no_orders?

          if expected[:content_type] && expected[:resource_types]
            match_cocina_type?(actual, expected) && match_contained_cocina_types?(actual, expected)
          elsif expected[:content_type] && expected[:viewing_direction]
            match_cocina_type?(actual, expected) && match_cocina_viewing_direction?(actual, expected)
          elsif expected[:content_type]
            match_cocina_type?(actual, expected)
          elsif expected[:resource_types]
            match_contained_cocina_types?(actual, expected)
          else
            raise ArgumentError, 'must provide content_type and/or resource_types keyword args'
          end
        end

        def match_no_orders?
          actual.structural.hasMemberOrders.blank?
        end

        def match_cocina_type?(actual, expected)
          actual.type == expected[:content_type]
        end

        def match_cocina_viewing_direction?(actual, expected)
          actual.structural.hasMemberOrders.map(&:viewingDirection).all? do |viewing_direction|
            viewing_direction == expected[:viewing_direction]
          end
        end

        def match_contained_cocina_types?(actual, expected)
          Array(actual.structural.contains).map(&:type).all? { |type| type.in?(expected[:resource_types]) }
        end
      end

      matcher :cocina_admin_policy_with_registration_collections do |expected|
        match do |actual|
          actual.type == Cocina::Models::ObjectType.admin_policy &&
            expected.all? { |collection_id| collection_id.in?(actual.administrative.collectionsForRegistration) }
        end
      end
    end
  end
end
