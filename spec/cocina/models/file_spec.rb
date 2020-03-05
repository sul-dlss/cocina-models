# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/file_shared_examples.rb'

RSpec.describe Cocina::Models::File do
  let(:file_type) { 'http://cocina.sul.stanford.edu/models/file.jsonld' }
  let(:required_properties) do
    {
      externalIdentifier: 'druid:ab123cd4567',
      label: 'My file',
      type: file_type,
      version: 3
    }
  end

  it_behaves_like 'it has file attributes'

  context 'when externalIdentifier is missing' do
    let(:item) { described_class.new(required_properties.reject { |k, _v| k == :externalIdentifier }) }

    it 'raises a Dry::Struct::Error' do
      err_msg = '[Cocina::Models::File.new] :externalIdentifier is missing in Hash input'
      expect { item }.to raise_error(Dry::Struct::Error, err_msg)
    end
  end

  describe 'Checkable model methods' do
    subject { described_class.new(required_properties) }

    it { is_expected.not_to be_admin_policy }
    it { is_expected.not_to be_collection }
    it { is_expected.not_to be_dro }
    it { is_expected.to be_file }
    it { is_expected.not_to be_file_set }
  end

  describe Cocina::Models::File::Administrative do
    let(:instance) { described_class.new(properties) }

    context 'with boolean properties as strings' do
      let(:properties) do
        {
          shelve: 'true',
          sdrPreserve: 'false'
        }
      end

      it 'coerces to boolean' do
        expect(instance.shelve).to be true
        expect(instance.sdrPreserve).to be false
      end
    end
  end

  describe Cocina::Models::File::Presentation do
    let(:instance) { described_class.new(properties) }

    context 'with height and width as strings' do
      let(:properties) do
        {
          height: '666',
          width: '777'
        }
      end

      it 'coerces to integer' do
        expect(instance.height).to eq 666
        expect(instance.width).to eq 777
      end
    end
  end
end
