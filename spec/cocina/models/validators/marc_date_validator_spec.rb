# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::MarcDateValidator do
  subject(:validate) { described_class.validate(date) }

  # YYYY
  context 'with a 4-digit year' do
    let(:date) { '1963' }

    it { is_expected.to be true }
  end

  context 'with uncertain year digits' do
    let(:date) { '19uu' }

    it { is_expected.to be true }
  end

  context 'with mostly uncertain year' do
    let(:date) { '1uuu' }

    it { is_expected.to be true }
  end

  context 'with open-ended range year (9999)' do
    let(:date) { '9999' }

    it { is_expected.to be true }
  end

  context 'with early century year' do
    let(:date) { '0946' }

    it { is_expected.to be true }
  end

  context 'with pipe characters (no attempt to code)' do
    let(:date) { '||||' }

    it { is_expected.to be true }
  end

  # YYMMDD
  context 'with a 6-digit date' do
    let(:date) { '630512' }

    it { is_expected.to be true }
  end

  context 'with a 6-digit date with uncertain day' do
    let(:date) { '6305uu' }

    it { is_expected.to be true }
  end

  # YYYYMMDD
  context 'with an 8-digit date' do
    let(:date) { '19630512' }

    it { is_expected.to be true }
  end

  context 'with an 8-digit date with uncertain day' do
    let(:date) { '196305uu' }

    it { is_expected.to be true }
  end

  context 'with all uncertain 8-digit date' do
    let(:date) { 'uuuuuuuu' }

    it { is_expected.to be true }
  end

  # Invalid cases
  context 'with a hyphenated date' do
    let(:date) { '1963-05' }

    it { is_expected.to be false }
  end

  context 'with a 3-digit value' do
    let(:date) { '196' }

    it { is_expected.to be false }
  end

  context 'with a 5-digit value' do
    let(:date) { '19635' }

    it { is_expected.to be false }
  end

  context 'with a 7-digit value' do
    let(:date) { '1963051' }

    it { is_expected.to be false }
  end

  context 'with a 9-digit value' do
    let(:date) { '196305120' }

    it { is_expected.to be false }
  end

  context 'with a pipe character in non-YYYY position' do
    let(:date) { '1963|512' }

    it { is_expected.to be false }
  end

  context 'with an empty string' do
    let(:date) { '' }

    it { is_expected.to be false }
  end
end
