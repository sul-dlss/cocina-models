# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Administrative do
  describe 'release tags array' do
    let(:administrative1) do
      described_class.new({
                            hasAdminPolicy: 'druid:bc123df4567'
                          })
    end

    let(:administrative2) do
      described_class.new({
                            hasAdminPolicy: 'druid:bc123df4567',
                            releaseTags: []
                          })
    end

    it 'normalizes array' do
      # Both of these administrative are logically equivalent for releaseTags.
      # They should normalize to the same.
      expect(administrative1.to_h).to eq(administrative2.to_h)
    end
  end

  describe 'mutation' do
    let(:administrative) do
      described_class.new(
        {
          hasAdminPolicy: 'druid:bc123df4567'
        }
      )
    end

    it 'provides a setter as a mutation facade' do
      administrative.hasAdminPolicy = 'druid:cb321fd7654'
      expect(administrative.hasAdminPolicy).to eq('druid:cb321fd7654')
    end
  end
end
