# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::Validator do
  subject(:validate) { described_class.validate(clazz, dro_props) }

  let(:clazz) { Cocina::Models::DRO }

  let(:dro_props) { props }

  let(:props) do
    {
      external_identifier: 'druid:jq000jd3530',
      description: {
        title: [{
          value: 'Rockhounding Utah',
          applies_to: [],
          grouped_value: [],
          identifier: [],
          note: [],
          parallel_value: [],
          structured_value: []
        }],
        purl: 'https://purl.stanford.edu/jq000jd3530'
      }
    }.with_indifferent_access
  end

  before do
    Cocina::Models::Validators::Validator::VALIDATORS.each do |validator_clazz|
      allow(validator_clazz).to receive(:validate)
    end
  end

  context 'with a props hash' do
    it 'invokes validators' do
      validate

      expect(Cocina::Models::Validators::Validator::VALIDATORS).to all(have_received(:validate).with(clazz,
                                                                                                     props))
    end
  end

  # Yes, this can happen.
  context 'with a mixed hash' do
    let(:dro_props) do
      {
        external_identifier: 'druid:jq000jd3530',
        description: {
          title: [Cocina::Models::Title.new(value: 'Rockhounding Utah')],
          purl: 'https://purl.stanford.edu/jq000jd3530'
        }
      }
    end

    it 'invokes validators' do
      validate

      expect(Cocina::Models::Validators::Validator::VALIDATORS).to all(have_received(:validate).with(clazz,
                                                                                                     props))
    end
  end
end
