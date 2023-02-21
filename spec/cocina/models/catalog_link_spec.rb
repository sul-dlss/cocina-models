# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Cocina::Models::CatalogLink' do
  let(:identification) { Cocina::Models::Identification.new(props) }

  context 'when only symphony catalog links' do
    let(:props) do
      {
        sourceId: 'sul:1234',
        catalogLinks: [
          {catalog: 'symphony', catalogRecordId: '12345', refresh: true},
          {catalog: 'previous symphony', catalogRecordId: '34567', refresh: false}
        ]
      }
    end

    it 'can be instantiated from a hash' do
      expect(identification).to be_a Cocina::Models::Identification
    end
  end

  context 'with symphony and folio catalog links' do
    let(:props) do
      {
        sourceId: 'sul:1234',
        catalogLinks: [
          {catalog: 'symphony', catalogRecordId: '12345', refresh: true},
          {catalog: 'previous symphony', catalogRecordId: '34567', refresh: false},
          {catalog: 'folio', catalogRecordId: '45678', refresh: false}
        ]
      }
    end

    it 'can be instantiated from a hash' do
      expect(identification).to be_a Cocina::Models::Identification
    end
  end
end
