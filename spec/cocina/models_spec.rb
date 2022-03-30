# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models do
  it 'has a version number' do
    expect(Cocina::Models::VERSION).not_to be_nil
  end

  describe '.build' do
    subject(:build) { described_class.build(data) }

    context 'with a collection type' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/exhibit',
          'externalIdentifier' => 'druid:bc123df4567',
          'label' => 'bar',
          'version' => 5,
          'access' => {},
          'description' => {
            'title' => [{ 'value' => 'Test Collection' }],
            'purl' => 'https://purl.stanford.edu/bc123df4567'
          },
          'identification' => {},
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_kind_of Cocina::Models::Collection }
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
        expect { build }.to raise_error(Cocina::Models::ValidationError)
      end
    end

    context 'with a DRO type' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/image',
          'externalIdentifier' => 'druid:bc123df4567',
          'label' => 'bar',
          'version' => 5,
          'access' => {},
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' },
          'identification' => {
            'doi' => '10.25740/bc123df4567',
            sourceId: 'sul:123'
          },
          'description' => {
            'title' => [{ 'value' => 'Test DRO' }],
            'purl' => 'https://purl.stanford.edu/bc123df4567'
          },
          'structural' => {}
        }
      end

      it { is_expected.to be_kind_of Cocina::Models::DRO }
    end

    context 'with an AdminPolicy type' do
      let(:data) do
        {
          'type' => 'https://cocina.sul.stanford.edu/models/admin_policy',
          'externalIdentifier' => 'druid:bc123df4567',
          'label' => 'bar',
          'version' => 5,
          'administrative' => {
            'hasAdminPolicy' => 'druid:bc123df4567',
            'hasAgreement' => 'druid:bc123df4567',
            'accessTemplate' => {}
          }
        }
      end

      it { is_expected.to be_kind_of Cocina::Models::AdminPolicy }
    end

    context 'with keys as symbols' do
      let(:data) do
        {
          type: 'https://cocina.sul.stanford.edu/models/image',
          externalIdentifier: 'druid:bc123df4567',
          label: 'bar',
          version: 5,
          access: {},
          administrative: { 'hasAdminPolicy' => 'druid:bc123df4567' },
          description: {
            title: [{ 'value' => 'Test DRO' }],
            purl: 'https://purl.stanford.edu/bc123df4567'
          },
          structural: {},
          identification: { sourceId: 'sul:123' }
        }
      end

      it { is_expected.to be_kind_of Cocina::Models::DRO }
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

      it { is_expected.to be_kind_of Cocina::Models::RequestCollection }
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

      it { is_expected.to be_kind_of Cocina::Models::RequestDRO }
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

      it { is_expected.to be_kind_of Cocina::Models::RequestAdminPolicy }
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

      it { is_expected.to be_kind_of Cocina::Models::RequestDRO }
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

    let(:cocina_object) do
      Cocina::Models::DROWithMetadata.new(
        type: 'https://cocina.sul.stanford.edu/models/image',
        externalIdentifier: 'druid:bc123df4567',
        label: 'bar',
        version: 5,
        access: {},
        administrative: { 'hasAdminPolicy' => 'druid:bc123df4567' },
        description: {
          title: [{ 'value' => 'Test DRO' }],
          purl: 'https://purl.stanford.edu/bc123df4567'
        },
        structural: {},
        identification: { sourceId: 'sul:123' },
        created: DateTime.now.iso8601,
        modified: DateTime.now.iso8601,
        lock: 'abc123'
      )
    end

    it { is_expected.to be_kind_of Cocina::Models::DRO }
  end

  describe '.with_metadata' do
    subject(:cocina_object_with_metadata) do
      described_class.with_metadata(cocina_object, 'abc123', created: date, modified: date)
    end

    let(:date) { DateTime.now }

    let(:props) do
      {
        type: 'https://cocina.sul.stanford.edu/models/image',
        externalIdentifier: 'druid:bc123df4567',
        label: 'bar',
        version: 5,
        access: {},
        administrative: { 'hasAdminPolicy' => 'druid:bc123df4567' },
        description: {
          title: [{ 'value' => 'Test DRO' }],
          purl: 'https://purl.stanford.edu/bc123df4567'
        },
        structural: {},
        identification: { sourceId: 'sul:123' }
      }
    end

    let(:cocina_object) { Cocina::Models::DRO.new(props) }

    let(:expected) do
      Cocina::Models::DROWithMetadata.new(props.merge({ lock: 'abc123', created: date, modified: date }))
    end

    it 'returns a DROWithMetadata' do
      expect(cocina_object_with_metadata).to be_kind_of Cocina::Models::DROWithMetadata
      expect(cocina_object_with_metadata).to match_cocina_object_with(expected.to_h)
    end
  end
end
