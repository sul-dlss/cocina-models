# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::ReleaseTag do
  context 'with release property as string' do
    let(:instance) { described_class.new(properties) }
    let(:properties) do
      {
        who: 'Justin',
        what: 'collection',
        date: '2018-11-23T00:44:52Z',
        to: 'Searchworks',
        release: 'true'
      }
    end

    it 'coerces to boolean' do
      expect(instance.release).to eq true
    end
  end
end
