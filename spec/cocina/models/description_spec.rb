# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Description do
  context 'with title primary property as string' do
    let(:instance) { described_class.new(properties) }
    let(:properties) do
      {
        title: [
          {
            primary: 'true',
            titleFull: 'true as string'
          },
          {
            primary: 'false',
            titleFull: 'false as string'
          }
        ]
      }
    end

    it 'coerces to boolean' do
      expect(instance.title.first.primary).to eq true
      expect(instance.title.last.primary).to eq false
    end
  end
end
