# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::ReservedFilenameVisitorValidator do
  subject(:validator) { described_class.new(attributes) }

  let(:attributes) { { externalIdentifier: 'druid:bc123df4567' } }

  def visit_and_validate(filename)
    validator.visit_file(file_hash: { filename: filename })
    validator.validate!
  end

  context 'when filename is not reserved' do
    it 'does not raise' do
      expect { visit_and_validate('test.txt') }.not_to raise_error
    end
  end

  context 'when filename matches bare druid' do
    it 'raises' do
      expect { visit_and_validate('bc123df4567') }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when filename starts with bare druid as base directory' do
    it 'raises' do
      expect { visit_and_validate('bc123df4567/file1.txt') }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'when bare druid appears in a non-root directory segment' do
    it 'does not raise' do
      expect { visit_and_validate('files/bc123df4567/file1.txt') }.not_to raise_error
    end
  end

  context 'when bare druid appears in a non-root position' do
    it 'does not raise' do
      expect { visit_and_validate('files/bc123df4567') }.not_to raise_error
    end
  end

  context 'when externalIdentifier is absent (e.g. RequestDRO)' do
    let(:attributes) { {} }

    it 'does not raise' do
      expect { visit_and_validate('bc123df4567') }.not_to raise_error
    end
  end

  context 'when file has no filename' do
    it 'does not raise' do
      validator.visit_file(file_hash: { label: 'Page 1' })
      expect { validator.validate! }.not_to raise_error
    end
  end
end
