# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models do
  it 'has a version number' do
    expect(Cocina::Models::VERSION).not_to be_nil
  end

  describe '.build' do
    subject(:model_build) { described_class.build(data) }

    context 'with a collection type' do
      let(:data) { build(:collection).to_h }

      it { is_expected.to be_a Cocina::Models::Collection }
    end

    context 'with an invalid DRO (openapi)' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'externalIdentifier' => 'foo',
          'label' => 'bar',
          'version' => 5,
          'access' => {}
        }
      end

      it 'raises' do
        expect { model_build }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'with a DRO type' do
      let(:data) { build(:dro).to_h }

      it { is_expected.to be_a Cocina::Models::DRO }
    end

    context 'with an AdminPolicy type' do
      let(:data) { build(:admin_policy).to_h }

      it { is_expected.to be_a Cocina::Models::AdminPolicy }
    end

    context 'with keys as strings' do
      let(:data) { build(:dro).to_h.deep_stringify_keys }

      it { is_expected.to be_a Cocina::Models::DRO }
    end

    context 'with an invalid type' do
      let(:data) do
        { 'type' => 'foo' }
      end

      it 'raises an error' do
        expect { model_build }.to raise_error Cocina::Models::UnknownTypeError, "Unknown type: 'foo'"
      end
    end

    context 'without a type' do
      let(:data) do
        {}
      end

      it 'raises an error' do
        expect { model_build }.to raise_error Cocina::Models::ValidationError
      end
    end
  end

  describe '.build_request' do
    subject(:build) { described_class.build_request(data) }

    context 'with a collection type' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/exhibit',
          'label' => 'bar',
          'version' => 1,
          'access' => {},
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestCollection }
    end

    context 'with a DRO type' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'label' => 'bar',
          'version' => 1,
          'identification' => {
            'sourceId' => 'sul:123'
          },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestDRO }
    end

    context 'with an AdminPolicy type' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/admin_policy',
          'label' => 'bar',
          'version' => 1,
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567',
            'hasAgreement' => 'druid:bc123df4567',
            'accessTemplate' => {}
          }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestAdminPolicy }
    end

    context 'with keys as symbols' do
      let(:data) do
        {
          type: 'https://cocina.sul.stanford.edu/models/image',
          label: 'bar',
          version: 1,
          identification: {
            sourceId: 'sul:123'
          },
          administrative: { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_a Cocina::Models::RequestDRO }
    end

    context 'with an invalid version' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/book',
          'label' => 'bar',
          'version' => 5,
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567',
            'hasAgreement' => 'druid:bc123df4567'
          }
        }
      end

      it 'raises an error' do
        expect do
          build
        end.to raise_error Cocina::Models::ValidationError,
                           "5 isn't part of the enum in #/components/schemas/RequestDRO/properties/version"
      end
    end

    context 'with an invalid type' do
      let(:data) do
        { 'type' => 'foo' }
      end

      it 'raises an error' do
        expect { build }.to raise_error Cocina::Models::UnknownTypeError, "Unknown type: 'foo'"
      end
    end

    context 'without a type' do
      let(:data) do
        {}
      end

      it 'raises an error' do
        expect { build }.to raise_error Cocina::Models::ValidationError
      end
    end
  end

  describe '.without_metadata' do
    subject(:cocina_object_without_metadata) { described_class.without_metadata(cocina_object) }

    let(:cocina_object) { build(:dro_with_metadata) }

    it { is_expected.to be_a Cocina::Models::DRO }
  end

  describe '.with_metadata' do
    subject(:cocina_object_with_metadata) do
      described_class.with_metadata(cocina_object, 'abc123', created: date, modified: date)
    end

    let(:date) { DateTime.now }

    let(:cocina_object) { build(:dro) }

    let(:props) { cocina_object.to_h }

    let(:expected) do
      Cocina::Models::DROWithMetadata.new(props.merge({ lock: 'abc123', created: date, modified: date }))
    end

    it 'returns a DROWithMetadata' do
      expect(cocina_object_with_metadata).to be_a Cocina::Models::DROWithMetadata
      expect(cocina_object_with_metadata).to match_cocina_object_with(expected.to_h)
    end
  end

  describe '.druid_regex' do
    subject(:druid_regex) { described_class.druid_regex }

    it 'matches druids' do
      expect(druid_regex).to match('druid:bc123df4567')
    end
  end
end
