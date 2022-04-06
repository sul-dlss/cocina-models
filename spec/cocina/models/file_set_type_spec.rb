# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::FileSetType do
  it 'provides vocab methods' do
    expect(described_class.file).to eq 'https://cocina.sul.stanford.edu/models/resources/file'
    expect(described_class.image).to eq 'https://cocina.sul.stanford.edu/models/resources/image'
  end

  it 'handles special main-original case' do
    expect(described_class.main_original).to eq 'https://cocina.sul.stanford.edu/models/resources/main-original'
  end

  it 'has a hash accessor' do
    expect(described_class['image']).to eq 'https://cocina.sul.stanford.edu/models/resources/image'
  end
end
