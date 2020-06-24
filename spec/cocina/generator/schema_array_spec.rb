# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Generator::SchemaArray do
  # This tests the outcome of running exe/generator generate against openapi.yml.

  # context 'when an array of datatypes' do
  #   # DescriptiveBasicValue.standard is an array of strings
  #   let(:value) { Cocina::Models::DescriptiveBasicValue.new(standard: %w[marc bibframe]) }
  # 
  #   it 'maps datatypes' do
  #     expect(value.standard).to eq(%w[marc bibframe])
  #   end
  # end

  context 'when an array of schemas' do
    # Administrative.releaseTags is an array of ReleaseTags

    let(:administrative) do
      Cocina::Models::Administrative.new(releaseTags: [
                                           {
                                             who: 'Justin',
                                             what: 'collection',
                                             date: '2018-11-23T00:44:52Z',
                                             to: 'Searchworks',
                                             release: true
                                           },
                                           {
                                             who: 'Other Justin',
                                             what: 'self',
                                             date: '2017-10-20T15:42:15Z',
                                             to: 'Searchworks',
                                             release: false
                                           }
                                         ],
                                         hasAdminPolicy: 'druid:bc123df4567')
    end

    it 'maps schemas' do
      expect(administrative.releaseTags.size).to eq(2)
      tag = administrative.releaseTags.first
      expect(tag.who).to eq('Justin')
      expect(tag.what).to eq('collection')
      expect(tag.date).to eq DateTime.parse '2018-11-23T00:44:52Z'
      expect(tag.to).to eq('Searchworks')
      expect(tag.release).to eq true
    end
  end

  context 'when array is required' do
    # Description.title is required
    context 'when array is provided' do
      let(:description) do
        Cocina::Models::Description.new({ title: [{ value: 'A Theory of Justice' }] }, false, false)
      end

      it 'handles required' do
        expect(description.title.first.value).to eq('A Theory of Justice')
      end
    end

    context 'when array is not provided' do
      let(:description) do
        Cocina::Models::Description.new({}, false, false)
      end

      it 'defaults to empty array' do
        expect(description.title).to eq([])
      end
    end
  end

  context 'when array is not required' do
    # Description.contributor is not required
    let(:description) do
      Cocina::Models::Description.new({}, false, false)
    end

    it 'defaults to nil' do
      expect(description.contributor).to be_nil
    end
  end
end
