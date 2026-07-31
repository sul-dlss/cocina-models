# frozen_string_literal: true

require 'spec_helper'
require_relative '../../bin/validation_error_collector'

RSpec.describe ValidationErrorCollector do
  subject(:errors) { described_class.call(json) }

  let(:dro) { build(:dro).to_h }

  context 'with a valid object' do
    let(:json) { dro }

    it 'reports no errors' do
      expect(errors).to be_empty
    end
  end

  context 'with several independent errors' do
    let(:json) do
      dro.tap do |props|
        props[:description][:purl] = 'https://purl.stanford.edu/zz999zz9999'
        props[:description][:contributor] = [{ name: [{ value: 'Anon' }], type: 'bogusType' }]
        props[:description][:language] = [{ code: 'zzz', source: { code: 'iso639-2b' } }]
        props[:description][:title] = [{ value: 'A title', type: 'alternative' }]
      end
    end

    it 'reports all of them rather than stopping at the first' do
      expect(errors).to include(
        a_string_matching(/Purl mismatch/),
        a_string_matching(/Unrecognized types in description/),
        a_string_matching(/Unrecognized language codes in description/),
        a_string_matching(/At least one title must have no type/)
      )
    end

    it 'reports what Cocina::Models.build alone would not' do
      build_error = begin
        Cocina::Models.build(json)
        nil
      rescue Cocina::Models::ValidationError => e
        e.message
      end

      expect(errors).to include(build_error)
      expect(errors.length).to be > 1
    end
  end

  # A top-level failure aborts construction, so Cocina::Models.build never validates the description.
  context 'with both a top-level error and a description error' do
    let(:json) do
      dro.tap do |props|
        props[:description][:purl] = 'https://purl.stanford.edu/zz999zz9999'
        props[:description][:contributor] = [{ name: [{ value: 'Anon' }], type: 'bogusType' }]
      end
    end

    it 'still validates the description' do
      expect(errors).to include(a_string_matching(/Unrecognized types in description/))
    end
  end

  # The composite validators walk the object once, then stop at the first sub-validator that raises.
  context 'with two errors from sub-validators of the same composite validator' do
    let(:json) do
      dro.tap do |props|
        props[:description][:contributor] = [{ name: [{ value: 'Anon' }], type: 'bogusType' }]
        props[:description][:language] = [{ code: 'zzz', source: { code: 'iso639-2b' } }]
      end
    end

    it 'reports both' do
      expect(errors).to include(
        a_string_matching(/Unrecognized types in description/),
        a_string_matching(/Unrecognized language codes in description/)
      )
    end
  end

  context 'when the object does not conform to the schema' do
    let(:json) { dro.merge(bogusKey: 1) }

    it 'reports the schema error alone, without downstream noise' do
      expect(errors).to eq(
        ["When validating DRO: Unevaluated properties are not allowed ('bogusKey' was unexpected)"]
      )
    end
  end

  context 'when a nested value has the wrong shape' do
    let(:json) { dro.merge(description: 'not an object') }

    it 'does not report NoMethodErrors from validators run against unusable data' do
      expect(errors).to eq(['When validating DRO: "not an object" is not of type "object" at /description'])
    end
  end

  context 'with an unknown type' do
    let(:json) { dro.merge(type: 'https://example.com/bogus') }

    it 'reports the type as unknown' do
      expect(errors).to eq(["Cocina::Models::UnknownTypeError: Unknown type: 'https://example.com/bogus'"])
    end
  end

  context 'with no type' do
    let(:json) { dro.except(:type) }

    it 'reports the missing type' do
      expect(errors).to eq(['Cocina::Models::ValidationError: Type field not found'])
    end
  end

  # The collector duplicates the class dispatch in Cocina::Models.build, whose type_for and
  # has_metadata? are private. This guards against the two drifting apart.
  describe 'class resolution' do
    {
      dro: Cocina::Models::DRO::TYPES,
      dro_with_metadata: Cocina::Models::DRO::TYPES,
      collection: Cocina::Models::Collection::TYPES,
      collection_with_metadata: Cocina::Models::Collection::TYPES,
      admin_policy: Cocina::Models::AdminPolicy::TYPES,
      admin_policy_with_metadata: Cocina::Models::AdminPolicy::TYPES
    }.each do |factory, types|
      it "resolves the same class the gem builds, for every #{factory} type" do
        types.each do |type|
          model = build(factory, type: type)

          expect(described_class.new(model.to_h).send(:clazz)).to eq(model.class)
        end
      end
    end
  end
end
