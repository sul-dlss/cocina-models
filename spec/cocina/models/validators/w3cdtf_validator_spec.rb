# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::W3cdtfValidator do
  subject(:validate) { described_class.validate(date) }

  context 'with a bad date' do
    let(:date) { '340' }

    it { is_expected.to be false }
  end

  context 'with a year' do
    let(:date) { '1997' }

    it { is_expected.to be true }
  end

  context 'with a year and month' do
    let(:date) { '1997-07' }

    it { is_expected.to be true }
  end

  context 'with a year and month out of range' do
    let(:date) { '1997-13' }

    it { is_expected.to be false }
  end

  context 'with a complete date' do
    let(:date) { '1997-07-16' }

    it { is_expected.to be true }
  end

  context 'with a compete date that has a day out of range' do
    let(:date) { '1997-02-30' }

    it { is_expected.to be false }
  end

  context 'with a complete date plus hours, minutes' do
    let(:date) { '1997-07-16T19:20+01:00' }

    it { is_expected.to be true }
  end

  context 'with a complete date plus hours, minutes, seconds' do
    let(:date) { '1997-07-16T19:20:30+01:00' }

    it { is_expected.to be true }
  end

  context 'with a complete date plus hours, minutes, seconds, and a decimal fraction of a second' do
    let(:date) { '1997-07-16T19:20:30.45+01:00' }

    it { is_expected.to be true }
  end

  context 'with a complete date + time, and UTC zone' do
    let(:date) { '1997-07-16T19:20Z' }

    it { is_expected.to be true }
  end

  context 'with a complete date + time, but missing TZ' do
    let(:date) { '1997-07-16T19:20' }

    it { is_expected.to be false }
  end
end
