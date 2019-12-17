# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Vocab do
  describe '.image' do
    subject { described_class.image }

    it { is_expected.to eq 'http://cocina.sul.stanford.edu/models/image.jsonld' }
  end
end
