# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Mapping::FromMods::Descriptive::ValueURI do
  describe '.sniff' do
    let(:notifier) { instance_double(Cocina::Models::Mapping::FromMods::ErrorNotifier) }

    before do
      allow(notifier).to receive(:warn)
    end

    context 'with a nil uri' do
      let(:uri) { nil }

      it 'returns the uri and does not warn' do
        expect(described_class.sniff(uri, notifier)).to eq(uri)
        expect(notifier).not_to have_received(:warn)
      end
    end

    context 'with a blank uri' do
      let(:uri) { '' }

      it 'returns nil and does not warn' do
        expect(described_class.sniff(uri, notifier)).to be_nil
        expect(notifier).not_to have_received(:warn)
      end
    end

    context 'with a string uri that starts with supported prefix' do
      let(:uri) { 'http://foo.example.edu' }

      it 'returns the uri and does not warn' do
        expect(described_class.sniff(uri, notifier)).to eq(uri)
        expect(notifier).not_to have_received(:warn)
      end
    end

    context 'with a string uri that does not start with supported prefix' do
      let(:uri) { '(OCoLC)fst01204289' }

      it 'returns the uri and warns' do
        expect(described_class.sniff(uri, notifier)).to eq(uri)
        expect(notifier).to have_received(:warn).with('Value URI has unexpected value', { uri: uri }).once
      end
    end
  end
end
