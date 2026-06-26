# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DescriptionSubjectSourceCodeVisitorValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { Cocina::Models::Validators::CompositeDescriptionValidator.new(clazz, props, validators: [described_class]).validate }

  let(:base_props) do
    {
      title: [{ value: 'Test Title' }],
      purl: 'https://purl.stanford.edu/bc123df4567'
    }.with_indifferent_access
  end

  describe 'when subject has no source' do
    let(:props) { base_props.merge(subject: [{ value: 'History' }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has source without code' do
    let(:props) { base_props.merge(subject: [{ value: 'History', source: { uri: 'https://example.com' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has a valid source code' do
    let(:props) { base_props.merge(subject: [{ value: 'History', source: { code: 'lcsh' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has a valid source code with different case' do
    let(:props) { base_props.merge(subject: [{ value: 'History', source: { code: 'LCSH' } }]) }

    it 'is case-insensitive and does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has an invalid source code' do
    let(:props) { base_props.merge(subject: [{ value: 'History', source: { code: 'bogusregistry' } }]) }

    it 'raises ValidationError with path and code' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Unrecognized subject source codes in description: subject1.source.code (bogusregistry)'
      )
    end
  end

  describe 'when using RequestDescription class' do
    let(:clazz) { Cocina::Models::RequestDescription }
    let(:props) { base_props.except(:purl).merge(subject: [{ value: 'History', source: { code: 'bogusregistry' } }]) }

    it 'raises ValidationError' do
      expect { validate }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  describe 'individual codes' do
    %w[local marcrelator WoRMS afs ISO19115TopicCategory].each do |code|
      describe "when subject has source code '#{code}'" do
        let(:props) { base_props.merge(subject: [{ value: 'History', source: { code: code } }]) }

        it 'does not raise' do
          expect { validate }.not_to raise_error
        end
      end
    end
  end

  describe 'when subject has fast source code' do
    let(:props) { base_props.merge(subject: [{ value: 'History', source: { code: 'fast' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has aat source code (genre-form list)' do
    let(:props) { base_props.merge(subject: [{ value: 'Photographs', source: { code: 'aat' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has marcgac source code (geographic-area list)' do
    let(:props) { base_props.merge(subject: [{ value: 'North America', source: { code: 'marcgac' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  describe 'when subject has iso3166 source code (country list)' do
    let(:props) { base_props.merge(subject: [{ value: 'US', source: { code: 'iso3166' } }]) }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end
end
