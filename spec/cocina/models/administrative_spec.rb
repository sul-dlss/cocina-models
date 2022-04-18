# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Administrative do
  describe 'release tags array' do
    let(:administrative1) do
      described_class.new({
                            has_admin_policy: 'druid:bc123df4567'
                          })
    end

    let(:administrative2) do
      described_class.new({
                            has_admin_policy: 'druid:bc123df4567',
                            release_tags: []
                          })
    end

    it 'normalizes array' do
      # Both of these administrative are logically equivalent for release_tags.
      # They should normalize to the same.
      expect(administrative1.to_h).to eq(administrative2.to_h)
    end
  end
end
