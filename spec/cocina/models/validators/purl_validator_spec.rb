# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::PurlValidator do
  subject(:validate) { described_class.validate(clazz, props) }

  let(:clazz) { Cocina::Models::DRO }

  context 'when valid' do
    let(:props) do
      {
        externalIdentifier: 'druid:jq000jd3530',
        description: {
          purl: 'https://purl.stanford.edu/jq000jd3530'
        }
      }
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when mismatch' do
    let(:props) do
      {
        externalIdentifier: 'druid:xq000jd3530',
        description: {
          purl: 'https://purl.stanford.edu/jq000jd3530'
        }
      }
    end

    it 'raises' do
      expect do
        validate
      end.to raise_error(Cocina::Models::ValidationError,
                         'Purl mismatch: druid:xq000jd3530 purl does not match object druid.')
    end
  end

  context 'when a request (no externalIdentifier)' do
    let(:props) { {} }

    let(:clazz) { Cocina::Models::RequestDRO }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when an AdminPolicy (description not required)' do
    let(:clazz) { Cocina::Models::AdminPolicy }

    let(:props) do
      {
        externalIdentifier: 'druid:jq000jd3530'
      }
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end
end
