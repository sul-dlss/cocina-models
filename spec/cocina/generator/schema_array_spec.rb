# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Generator::SchemaArray do
  # This tests the outcome of running exe/generator generate against openapi.yml.
  context 'when array is required' do
    # Description.title is required
    context 'when array is provided' do
      let(:description) do
        Cocina::Models::RequestDescription.new({ title: [{ value: 'A Theory of Justice' }] }, false, false)
      end

      it 'handles required' do
        expect(description.title.first.value).to eq('A Theory of Justice')
      end
    end

    context 'when array is not provided' do
      let(:description) do
        Cocina::Models::RequestDescription.new({}, false, false)
      end

      it 'defaults to empty array' do
        expect(description.title).to eq([])
      end
    end
  end

  context 'when array is not required' do
    # Description.contributor is not required
    let(:description) do
      Cocina::Models::RequestDescription.new({}, false, false)
    end

    it 'defaults to empty array' do
      expect(description.contributor).to eq([])
    end
  end
end
