# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::ShelveOnlyVisitorValidator do
  subject(:validator) { described_class.new({}) }

  let(:file) do
    {
      filename: 'page1.txt',
      administrative: { shelve: true, publish: false, sdrPreserve: false }
    }
  end

  context 'when shelve=true, publish=false, sdrPreserve=false' do
    it 'raises' do
      validator.visit_file(file_hash: file)
      expect { validator.validate! }.to raise_error(Cocina::Models::ValidationError)
    end
  end
end
