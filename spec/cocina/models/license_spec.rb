# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::License do
  it 'provides vocab methods' do
    expect(described_class.none).to eq('https://cocina.sul.stanford.edu/licenses/none')
  end
end
