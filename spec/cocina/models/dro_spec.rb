# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::DRO do
  describe '.from_json' do
    let(:json) do
      <<~JSON
        {
          "externalIdentifier":"druid:12343234",
          "type":"item",
          "label":"my item"
        }
      JSON
    end

    subject(:dro) { described_class.from_json(json) }

    it 'has the attributes' do
      expect(dro.attributes).to eq(externalIdentifier: 'druid:12343234',
                                   label: 'my item',
                                   type: 'item')
    end
  end
end
