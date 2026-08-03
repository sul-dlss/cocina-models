# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::MapCoordinatesValidator do
  describe '.valid_coordinate?' do
    subject(:validate) { described_class.valid_coordinate?(value) }

    context 'with hdddmmss' do
      let(:value) { 'W1800000' }

      it { is_expected.to be true }
    end

    context 'with a second hdddmmss value' do
      let(:value) { 'N0840000' }

      it { is_expected.to be true }
    end

    context 'with hddd.dddddd' do
      let(:value) { 'E079.533265' }

      it { is_expected.to be true }
    end

    context 'with +ddd.dddddd' do
      let(:value) { '+079.533265' }

      it { is_expected.to be true }
    end

    context 'with -ddd.dddddd' do
      let(:value) { '-012.583377' }

      it { is_expected.to be true }
    end

    context 'with ddd.dddddd (no sign)' do
      let(:value) { '079.533265' }

      it { is_expected.to be true }
    end

    context 'with hdddmm.mmmm' do
      let(:value) { 'E07932.5332' }

      it { is_expected.to be true }
    end

    context 'with hdddmmss.sss' do
      let(:value) { 'E0793235.575' }

      it { is_expected.to be true }
    end

    context 'with a lowercase hemisphere' do
      let(:value) { 'w1800000' }

      it { is_expected.to be true }
    end

    context 'with an unpadded decimal degree, no hemisphere (spreadsheet-style lat/long)' do
      let(:value) { '34.68444444' }

      it { is_expected.to be true }
    end

    context 'with an empty string' do
      let(:value) { '' }

      it { is_expected.to be false }
    end

    context 'with a value that is too short' do
      let(:value) { 'W18' }

      it { is_expected.to be false }
    end

    context 'with a value that is too long' do
      let(:value) { 'W18000000' }

      it { is_expected.to be false }
    end

    context 'with a non-numeric value' do
      let(:value) { 'not a coordinate' }

      it { is_expected.to be false }
    end

    context 'with an invalid hemisphere letter' do
      let(:value) { 'X1800000' }

      it { is_expected.to be false }
    end
  end

  describe '.valid_range?' do
    subject(:validate) { described_class.valid_range?(value) }

    context 'with a degrees-only range' do
      let(:value) { 'W 150°--W 30°/N 70°--N 40°' }

      it { is_expected.to be true }
    end

    context 'with a degrees/minutes range' do
      let(:value) { 'W 74°50ʹ--W 74°40ʹ/N 45°05ʹ--N 45°00ʹ' }

      it { is_expected.to be true }
    end

    context 'with a range where the second term omits the hemisphere' do
      let(:value) { 'W 79°33ʹ--78°34ʹ/N 42°04ʹ--N 41°15ʹ' }

      it { is_expected.to be true }
    end

    context 'with a degrees/minutes/seconds range' do
      let(:value) { 'W 104°45ʹ00ʺ--W 103°17ʹ11ʺ/N 44°49ʹ23ʺ--N 43°16ʹ10ʺ' }

      it { is_expected.to be true }
    end

    context 'with decimal degrees' do
      let(:value) { 'E 79.533265°--E 86.216635°/S 12.583377°--S 20.419532°' }

      it { is_expected.to be true }
    end

    context 'with decimal minutes' do
      let(:value) { 'E 079°32.5332ʹ--E 086°07.4478ʹ/S 012°35.5421ʹ--S 020°28.9704ʹ' }

      it { is_expected.to be true }
    end

    context 'with decimal seconds' do
      let(:value) { 'E 79°32ʹ35.575ʺ--E 86°07ʹ27.350ʺ/S 1°25ʹ36.895ʺ--S 20°28ʹ58.125ʺ' }

      it { is_expected.to be true }
    end

    context 'with a center point instead of a bounding box' do
      let(:value) { 'W 95°05ʹ/N 30°03ʹ' }

      it { is_expected.to be true }
    end

    context 'with a decimal center point and no degree symbols' do
      let(:value) { 'W 119.697222/N 034.420833' }

      it { is_expected.to be true }
    end

    context 'when wrapped in parentheses' do
      let(:value) { '(W 150°--W 30°/N 70°--N 40°)' }

      it { is_expected.to be true }
    end

    context 'when wrapped in parentheses and followed by a period' do
      let(:value) { '(W 150°--W 30°/N 70°--N 40°).' }

      it { is_expected.to be true }
    end

    context 'with an empty string' do
      let(:value) { '' }

      it { is_expected.to be false }
    end

    context 'when missing the "/" separator' do
      let(:value) { 'W 150°--W 30° N 70°--N 40°' }

      it { is_expected.to be false }
    end

    context 'with a non-coordinate string' do
      let(:value) { 'not a coordinate' }

      it { is_expected.to be false }
    end
  end
end
