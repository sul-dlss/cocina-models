# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Generator::SchemaValue do
  # This tests the outcome of running exe/generator generate against openapi.yml.

  context 'when property is an integer' do
    # RequestDRO.version is an integer
    let(:dro) do
      Cocina::Models::RequestDRO.new({
                                       label: 'The Prince',
                                       type: Cocina::Models::Vocab.book,
                                       version: 5,
                                       identification: { sourceId: 'sul:123' },
                                       administrative: { hasAdminPolicy: 'druid:bc123df4567' }
                                     }, false, false)
    end

    it 'maps to integer' do
      expect(dro.version).to eq(5)
    end
  end

  context 'when property is a string' do
    # RequestDRO.label is an integer
    let(:dro) do
      Cocina::Models::RequestDRO.new({
                                       label: 'The Blue and Brown Books',
                                       type: Cocina::Models::Vocab.book,
                                       version: 5,
                                       identification: { sourceId: 'sul:123' },
                                       administrative: { hasAdminPolicy: 'druid:bc123df4567' }
                                     }, false, false)
    end

    it 'maps to string' do
      expect(dro.label).to eq('The Blue and Brown Books')
    end
  end

  context 'when property is a boolean' do
    # FileAdministrative.shelve and .sdrPreserve are boolean
    let(:administrative) { Cocina::Models::FileAdministrative.new(sdrPreserve: false, shelve: true) }

    it 'maps to boolean' do
      expect(administrative.sdrPreserve).to be false
      expect(administrative.shelve).to be true
    end
  end

  context 'when property is a string with date-time format' do
    # Embargo.releaseDate is a date-time
    let(:embargo) { Cocina::Models::Embargo.new(releaseDate: '2009-12-14T07:00:00Z', access: 'world') }

    it 'maps to datetime' do
      expect(embargo.releaseDate).to eq DateTime.parse('2009-12-14T07:00:00Z')
    end
  end

  context 'when property is an enum' do
    # Embargo.access is an enum
    context 'when value is in enum list' do
      let(:embargo) { Cocina::Models::Embargo.new(releaseDate: '2009-12-14T07:00:00Z', access: 'world') }

      it 'maps to an enum' do
        expect(embargo.access).to eq('world')
      end
    end

    context 'when value is not in enum list' do
      let(:embargo) { Cocina::Models::Embargo.new(releaseDate: '2009-12-14T07:00:00Z', access: 'my office') }

      it 'raises' do
        expect { embargo }.to raise_error(Dry::Struct::Error)
      end
    end

    context 'when a type enum' do
      it 'has a TYPES constant' do
        expect(Cocina::Models::FileSet::TYPES).to include 'http://cocina.sul.stanford.edu/models/resources/page.jsonld'
      end
    end
  end

  context 'when property is an integer or a string' do
    # DescriptiveBasicValue.value is an Any
    subject { dro.value }

    let(:dro) do
      Cocina::Models::DescriptiveBasicValue.new({
                                                  value: value
                                                })
    end

    context 'when a string is provided' do
      let(:value) { '5' }

      it { is_expected.to eq '5' }
    end

    context 'when an integer is provided' do
      let(:value) { 6 }

      it { is_expected.to eq 6 }
    end
  end

  context 'when property is required' do
    # Geographic.iso19139 is required
    context 'when provided' do
      let(:geo) { Cocina::Models::Geographic.new(iso19139: '<gmd:MD_Metadata />') }

      it 'handles required' do
        expect(geo.iso19139).to eq('<gmd:MD_Metadata />')
      end
    end

    context 'when not provided' do
      let(:geo) { Cocina::Models::Geographic.new }

      it 'raises' do
        expect { geo }.to raise_error(Dry::Struct::Error)
      end
    end
  end

  context 'when property is not required' do
    # Identification.sourceId is omittable
    let(:identification) { Cocina::Models::Identification.new }

    it 'handles omittable' do
      expect(identification.sourceId).to be_nil
    end
  end

  context 'when property has a default' do
    # Access.access has a default
    let(:access) { Cocina::Models::Access.new }

    it 'default is provided' do
      expect(access.access).to eq('dark')
    end
  end
end
