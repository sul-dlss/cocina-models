# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Mapping::FromMarc::Title do
  describe '.build' do
    subject(:build) do
      described_class.build(marc: marc, require_title: require_title, notifier: notifier)
    end

    let(:notifier) { instance_double(Cocina::Models::Mapping::ErrorNotifier) }
    let(:require_title) { true }
    let(:marc) { MARC::Record.new_from_hash(marc_hash) }

    context 'with no title fields' do
      let(:marc_hash) do
        {
          'fields' => [
            { 'xxx' => { 'subfields' => [{ 'a' => 'nothing' }] } }
          ]
        }
      end

      before do
        allow(notifier).to receive(:error)
        allow(notifier).to receive(:warn)
      end

      it 'returns empty and notifies error' do
        expect(build).to be_nil
        expect(notifier).to have_received(:error).with('Missing title')
      end
    end

    context 'with a basic title field' do
      let(:marc_hash) do
        {
          'fields' => [
            { '245' => { 'ind1' => '1', 'ind2' => '0', 'subfields' => [{ 'a' => 'Gaudy night /' }, {'c' => 'by Dorothy L. Sayers'}] } }
          ]
        }
      end

      it 'returns the title' do
        expect(build).to eq([{ value: 'Gaudy night' }])
      end
    end
  end
end
