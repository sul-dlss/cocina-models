# frozen_string_literal: true

# Deeply compares two objects, ignoring array order.
# Based on https://github.com/amogil/rspec-deep-ignore-order-matcher/blob/master/lib/rspec_deep_ignore_order_matcher.rb
class DeepEqual
  def self.match?(actual, expected)
    new(actual, expected).match?
  end

  def initialize(actual, expected)
    @actual = actual
    @expected = expected
  end

  def match?
    objects_match?(actual, expected)
  end

  private

  attr_reader :actual, :expected

  def objects_match?(actual_obj, expected_obj)
    return arrays_match?(actual_obj, expected_obj) if expected_obj.is_a?(Array) && actual_obj.is_a?(Array)
    return hashes_match?(actual_obj, expected_obj) if expected_obj.is_a?(Hash) && actual_obj.is_a?(Hash)

    expected_obj == actual_obj
  end

  def arrays_match?(actual_array, expected_array)
    exp = expected_array.clone
    actual_array.each do |a|
      index = exp.find_index { |e| objects_match? a, e }
      return false if index.nil?

      exp.delete_at(index)
    end
    exp.empty?
  end

  def hashes_match?(actual_hash, expected_hash)
    return false unless actual_hash.keys.sort == expected_hash.keys.sort

    actual_hash.each do |key, value|
      return false unless objects_match?(value, expected_hash[key])
    end

    true
  end
end

# Based on https://github.com/amogil/rspec-deep-ignore-order-matcher/blob/master/lib/rspec_deep_ignore_order_matcher.rb
RSpec::Matchers.define :be_deep_equal do |expected|
  match { |actual| DeepEqual.match?(actual, expected) }

  # Added diffable because it is helpful for troubleshooting, even if it mistakenly adds spurious diffs.
  diffable

  failure_message do |actual|
    "expected that #{actual} would be deep equal with #{expected}. Differences in order shown in diff CAN BE IGNORED."
  end

  failure_message_when_negated do |actual|
    "expected that #{actual} would not be deep equal with #{expected}. Differences in order shown in diff CAN BE IGNORED."
  end

  description do
    "be deep equal with #{expected}"
  end
end
