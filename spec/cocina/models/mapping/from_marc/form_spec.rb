# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Mapping::FromMarc::Form do
  describe '.build' do
    subject(:build) do
      described_class.build(marc: marc)
    end

    let(:marc) { MARC::Record.new_from_hash(marc_hash) }

    context 'with extent (300 $abcefg3)' do
      # see a14723913
      let(:marc_hash) do
        {
          'fields' => [
            { '300' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'a' => '1 accordion-fold book (unpaged) :' },
                { 'b' => 'color illustrations ;' },
                { 'c' => '37 cm +' },
                { 'e' => '1 volume (xxi, 59 pages : color illustrations ; 24 cm) + 2 SD cards + 1 digital viewer + 1 laser cut printing plate, in 2 clamshell boxes 40 x 28 x 5 cm' }
              ]
            } }
          ]
        }
      end

      it 'returns extent value' do
        expect(build).to eq([{ value: '1 accordion-fold book (unpaged) : color illustrations ; 37 cm + 1 volume (xxi, 59 pages : color illustrations ; 24 cm) + 2 SD cards + 1 digital viewer + 1 laser cut printing plate, in 2 clamshell boxes 40 x 28 x 5 cm' }])
      end
    end

    context 'with extent (300 $3afg)' do
      # LC example
      let(:marc_hash) do
        {
          'fields' => [
            { '300' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { '3' => 'records' },
                { 'a' => '1' },
                { 'f' => 'box' },
                { 'g' => '2 x 4 x 3 1/2 ft.' }
              ]
            } }
          ]
        }
      end

      it 'returns extent value with $3' do
        expect(build).to eq([{ value: 'records 1 box 2 x 4 x 3 1/2 ft.' }])
      end
    end

    context 'with material base (340 $a)' do
      # see in00000022114
      let(:marc_hash) do
        {
          'fields' => [
            { '340' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'a' => 'paper' },
                { '2' => 'rdamat' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Material base and configuration display label' do
        expect(build).to eq([{ note: [{ value: 'paper', displayLabel: 'Material base and configuration' }] }])
      end
    end

    context 'with dimensions (340 $b)' do
      # LC example
      let(:marc_hash) do
        {
          'fields' => [
            { '340' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'b' => '20 cm. folded to 10 x 12 cm.' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Dimensions display label' do
        expect(build).to eq([{ note: [{ value: '20 cm. folded to 10 x 12 cm.', displayLabel: 'Dimensions' }] }])
      end
    end

    context 'with surface materials (340 $c)' do
      # see in00000022114
      let(:marc_hash) do
        {
          'fields' => [
            { '340' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'c' => 'ink' },
                { '2' => 'rdamat' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Materials applied to surface display label' do
        expect(build).to eq([{ note: [{ value: 'ink', displayLabel: 'Materials applied to surface' }] }])
      end
    end

    context 'with recording (340 $d)' do
      # see in00000022114
      let(:marc_hash) do
        {
          'fields' => [
            { '340' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'd' => 'handwritten' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Information recording technique display label' do
        expect(build).to eq([{ note: [{ value: 'handwritten', displayLabel: 'Information recording technique' }] }])
      end
    end

    context 'with tech specs (340 $i)' do
      # LC example
      let(:marc_hash) do
        {
          'fields' => [
            { '340' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'i' => 'Ibord Model 74 tape reader.' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Technical specifications of medium display label' do
        expect(build).to eq([{ note: [{ value: 'Ibord Model 74 tape reader.', displayLabel: 'Technical specifications of medium' }] }])
      end
    end

    context 'with generation (340 $j)' do
      # LC example
      let(:marc_hash) do
        {
          'fields' => [
            { '340' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'j' => 'original' },
                { '2' => 'rdagen' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Generation display label' do
        expect(build).to eq([{ note: [{ value: 'original', displayLabel: 'Generation' }] }])
      end
    end

    context 'with recording type (344 $a)' do
      # see a14349595
      let(:marc_hash) do
        {
          'fields' => [
            { '344' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'a' => 'analog' },
                { '2' => 'rdatr' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Type of recording display label' do
        expect(build).to eq([{ note: [{ value: 'analog', displayLabel: 'Type of recording' }] }])
      end
    end

    context 'with recording medium (344 $b)' do
      # see a14354567
      let(:marc_hash) do
        {
          'fields' => [
            { '344' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'b' => 'optical' },
                { '2' => 'rdarm' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Recording medium display label' do
        expect(build).to eq([{ note: [{ value: 'optical', displayLabel: 'Recording medium' }] }])
      end
    end

    context 'with playing speed (344 $c)' do
      # see a14349595
      let(:marc_hash) do
        {
          'fields' => [
            { '344' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'c' => '78 rpm' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Playing speed display label' do
        expect(build).to eq([{ note: [{ value: '78 rpm', displayLabel: 'Playing speed' }] }])
      end
    end

    context 'with groove (344 $d)' do
      # see in00000892026
      let(:marc_hash) do
        {
          'fields' => [
            { '344' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'd' => 'coarse groove' },
                { '2' => 'rdagw' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Groove characteristic display label' do
        expect(build).to eq([{ note: [{ value: 'coarse groove', displayLabel: 'Groove characteristic' }] }])
      end
    end

    context 'with track (344 $e)' do
      # LC example
      let(:marc_hash) do
        {
          'fields' => [
            { '344' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'e' => 'edge track' },
                { '2' => 'rdatc' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Track configuration display label' do
        expect(build).to eq([{ note: [{ value: 'edge track', displayLabel: 'Track configuration' }] }])
      end
    end

    context 'with tape (344 $f)' do
      # LC example
      let(:marc_hash) do
        {
          'fields' => [
            { '344' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'f' => '12 track' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Tape configuration display label' do
        expect(build).to eq([{ note: [{ value: '12 track', displayLabel: 'Tape configuration' }] }])
      end
    end

    context 'with playback channels (344 $g)' do
      # see a14349595
      let(:marc_hash) do
        {
          'fields' => [
            { '344' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'g' => 'mono' },
                { '2' => 'rdacpc' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Configuration of playback channels display label' do
        expect(build).to eq([{ note: [{ value: 'mono', displayLabel: 'Configuration of playback channels' }] }])
      end
    end

    context 'with playback characteristics (344 $h)' do
      # see a14354567
      let(:marc_hash) do
        {
          'fields' => [
            { '344' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'h' => 'Dolby Digital' }
              ]
            } }
          ]
        }
      end

      it 'returns note with Special playback characteristics display label' do
        expect(build).to eq([{ note: [{ value: 'Dolby Digital', displayLabel: 'Special playback characteristics' }] }])
      end
    end

    context 'with arrangement (351 $abc3)' do
      # based on a6002746
      let(:marc_hash) do
        {
          'fields' => [
            { '351' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { '3' => 'Records' },
                { 'c' => 'Series;' },
                { 'a' => 'Organized into six series: 1. Correspondence. 2. Literary Works. 3. Documents and Ephemera. 4. Photos. 5. Miscellaneous. 6. Scrapbook.' },
                { 'b' => 'Arranged by form of material.' }
              ]
            } }
          ]
        }
      end

      it 'returns note with arrangement type' do
        expect(build).to eq([{ note: [{ type: 'arrangement', value: 'Records Series; Organized into six series: 1. Correspondence. 2. Literary Works. 3. Documents and Ephemera. 4. Photos. 5. Miscellaneous. 6. Scrapbook. Arranged by form of material.' }] }])
      end
    end

    context 'with genre (655 $a)' do
      # see a12365535
      let(:marc_hash) do
        {
          'fields' => [
            { '655' => {
              'ind1' => ' ', 'ind2' => '7',
              'subfields' => [
                { 'a' => 'Excerpts.' },
                { '2' => 'lcgft' },
                { '0' => 'http://id.loc.gov/authorities/genreForms/gf2014026097' },
                { '0' => '(SIRSI)3344823' }
              ]
            } }
          ]
        }
      end

      it 'returns genre value with trailing punctuation stripped' do
        expect(build).to eq([{ value: 'Excerpts.', type: 'genre' }])
      end
    end

    context 'with map scale (255 $a)' do
      # see a12836911
      let(:marc_hash) do
        {
          'fields' => [
            { '255' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'a' => 'Scale not given.' }
              ]
            } }
          ]
        }
      end

      it 'returns map scale type' do
        expect(build).to eq([{ value: 'Scale not given.', type: 'map scale' }])
      end
    end

    context 'with map projection (255 $b)' do
      # based on a13180303
      let(:marc_hash) do
        {
          'fields' => [
            { '255' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'b' => 'projection: UTM Zone 28' }
              ]
            } }
          ]
        }
      end

      it 'returns map projection type' do
        expect(build).to eq([{ value: 'projection: UTM Zone 28', type: 'map projection' }])
      end
    end

    context 'with content type (336 $a)' do
      # see in00000861694
      let(:marc_hash) do
        {
          'fields' => [
            { '336' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'a' => 'text' },
                { 'b' => 'txt' },
                { '2' => 'rdacontent' }
              ]
            } },
            { '336' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'a' => 'still image' },
                { 'b' => 'sti' },
                { '2' => 'rdacontent' }
              ]
            } },
            { '336' => {
              'ind1' => ' ', 'ind2' => ' ',
              'subfields' => [
                { 'a' => 'cartographic image' },
                { 'b' => 'cri' },
                { '2' => 'rdacontent' }
              ]
            } }
          ]
        }
      end

      it 'returns multiple genre values' do
        expect(build).to eq([
                              { value: 'text', type: 'genre' },
                              { value: 'still image', type: 'genre' },
                              { value: 'cartographic image', type: 'genre' }
                            ])
      end
    end

    context 'with dataset (008/26 = a and Leader/06 = m)' do
      # see a12827086
      let(:marc_hash) do
        {
          'leader' => '00584cmm a22001575  4500',
          'fields' => [
            { '008' => '181113m20149999miu        a  000 0 eng u' }
          ]
        }
      end

      it 'returns dataset genre' do
        expect(build).to eq([{ value: 'dataset', type: 'genre' }])
      end
    end
  end
end
