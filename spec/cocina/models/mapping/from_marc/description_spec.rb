# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Mapping::FromMarc::Description do
  subject(:descriptive) do
    described_class.props(marc:, druid: 'druid:bb196dd3409', notifier: notifier, label: 'test label')
  end

  let(:notifier) { instance_double(Cocina::Models::Mapping::ErrorNotifier) }

  context 'when the mapping is successful' do
    let(:marc) do
      {
        'fields' => [
          { '245' => { 'ind1' => '1', 'ind2' => '0', 'subfields' => [{ 'a' => 'Gaudy night /' }, { 'c' => 'by Dorothy L. Sayers' }] } }
        ]
      }
    end

    it 'returns the descriptive metadata including title and purl' do
      expect(descriptive).to eq({
                                  title: [{ value: 'Gaudy night' }],
                                  purl: 'https://purl.stanford.edu/bb196dd3409'
                                })
    end
  end

  context 'when the MARC has no title' do
    let(:marc) do
      {
        'fields' => []
      }
    end

    before do
      allow(notifier).to receive(:warn)
      allow(notifier).to receive(:error)
    end

    it 'notifies and returns the descriptive metadata with a default title' do
      descriptive
      expect(notifier).to have_received(:warn).with('No title fields found')
      expect(notifier).to have_received(:error).with('Missing title')
      expect(descriptive).to eq({
                                  title: [{ value: 'test label' }],
                                  purl: 'https://purl.stanford.edu/bb196dd3409'
                                })
    end
  end

  context 'when the MARC is nil' do
    let(:marc) { nil }

    it 'returns nil' do
      expect(descriptive).to be_nil
    end
  end
end
