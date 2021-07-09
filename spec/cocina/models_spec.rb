# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models do
  it 'has a version number' do
    expect(Cocina::Models::VERSION).not_to be nil
  end

  describe '.build' do
    subject(:build) { described_class.build(data) }

    context 'with a collection type' do
      let(:data) do
        {
          'type' => 'http://cocina.sul.stanford.edu/models/exhibit.jsonld',
          'externalIdentifier' => 'druid:bc123df4567',
          'label' => 'bar',
          'version' => 5,
          'access' => {}
        }
      end

      it { is_expected.to be_kind_of Cocina::Models::Collection }
    end

    context 'with an invalid DRO (openapi)' do
      let(:data) do
        {
          'type' => 'http://cocina.sul.stanford.edu/models/image.jsonld',
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
          'type' => 'http://cocina.sul.stanford.edu/models/image.jsonld',
          'externalIdentifier' => 'druid:bc123df4567',
          'label' => 'bar',
          'version' => 5,
          'access' => {},
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_kind_of Cocina::Models::DRO }
    end

    context 'with an AdminPolicy type' do
      let(:data) do
        {
          'type' => 'http://cocina.sul.stanford.edu/models/admin_policy.jsonld',
          'externalIdentifier' => 'druid:bc123df4567',
          'label' => 'bar',
          'version' => 5,
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_kind_of Cocina::Models::AdminPolicy }
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
        expect { build }.to raise_error KeyError
      end
    end
  end

  describe '.build_request' do
    subject(:build) { described_class.build_request(data) }

    context 'with a collection type' do
      let(:data) do
        {
          'type' => 'http://cocina.sul.stanford.edu/models/exhibit.jsonld',
          'label' => 'bar',
          'version' => 5,
          'access' => {},
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_kind_of Cocina::Models::RequestCollection }
    end

    context 'with a DRO type' do
      let(:data) do
        {
          'type' => 'http://cocina.sul.stanford.edu/models/image.jsonld',
          'label' => 'bar',
          'version' => 5,
          'identification' => {
            'sourceId' => 'sul:123',
            'doi' => '10.25740/bc123df4567'
          },
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_kind_of Cocina::Models::RequestDRO }
    end

    context 'with an AdminPolicy type' do
      let(:data) do
        {
          'type' => 'http://cocina.sul.stanford.edu/models/admin_policy.jsonld',
          'label' => 'bar',
          'version' => 5,
          'administrative' => { 'hasAdminPolicy' => 'druid:bc123df4567' }
        }
      end

      it { is_expected.to be_kind_of Cocina::Models::RequestAdminPolicy }
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
        expect { build }.to raise_error KeyError
      end
    end
  end
end
