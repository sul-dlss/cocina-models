# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::BaseStructuralVisitorValidator do
  subject(:validator) { described_class.new({}) }

  it 'does not raise on visit_file' do
    expect { validator.visit_file(file_hash: { filename: 'test.txt' }) }.not_to raise_error
  end

  it 'does not raise on validate!' do
    expect { validator.validate! }.not_to raise_error
  end
end
