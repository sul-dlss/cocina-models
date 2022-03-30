# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Generator::SchemaValue do
  # This tests the outcome of running exe/generator generate against openapi.yml.

  context 'when property is an integer' do
    # RequestDRO.version is an integer
    let(:dro) do
      Cocina::Models::RequestDRO.new({
                                       label: 'The Prince',
                                       type: Cocina::Models::ObjectType.book,
                                       version: 1,
                                       identification: { sourceId: 'sul:123' },
                                       administrative: { hasAdminPolicy: 'druid:bc123df4567' }
                                     }, false, false)
    end

    it 'maps to integer' do
      expect(dro.version).to eq 1
    end
  end

  context 'when property is a string' do
    # RequestDRO.label is an integer
    let(:dro) do
      Cocina::Models::RequestDRO.new({
                                       label: 'The Blue and Brown Books',
                                       type: Cocina::Models::ObjectType.book,
                                       version: 1,
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
    let(:embargo) { Cocina::Models::Embargo.new(releaseDate: '2009-12-14T07:00:00Z', view: 'world') }

    it 'maps to datetime' do
      expect(embargo.releaseDate).to eq DateTime.parse('2009-12-14T07:00:00Z')
    end
  end

  context 'when property is an enum' do
    # AccessRole.name is an enum
    context 'when value is in enum list' do
      let(:role) { Cocina::Models::AccessRole.new(name: 'dor-apo-creator') }

      it 'maps to an enum' do
        expect(role.name).to eq('dor-apo-creator')
      end
    end

    context 'when value is not in enum list' do
      let(:role) { Cocina::Models::AccessRole.new(name: 'the-creator') }

      it 'raises' do
        expect { role }.to raise_error(Dry::Struct::Error)
      end
    end

    context 'when a type enum' do
      it 'has a TYPES constant' do
        expect(Cocina::Models::FileSet::TYPES).to include 'https://cocina.sul.stanford.edu/models/resources/page'
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
    context 'when the value is omitted and has no default' do
      # DROAccess.location is not required
      let(:access) { Cocina::Models::DROAccess.new }

      it 'sets to nil' do
        expect(access.location).to be_nil
      end
    end

    context 'when the value is omitted and has a default' do
      # DROAccess.download is not required and has a default
      let(:access) { Cocina::Models::DROAccess.new }

      it 'sets to the default' do
        expect(access.download).to eq 'none'
      end
    end
  end

  context 'when property is nullable' do
    context 'when the value set to nil' do
      let(:default_access) { Cocina::Models::AdminPolicyAccessTemplate.new(copyright: nil) }

      it 'sets to nil' do
        expect(default_access.copyright).to be_nil
      end
    end
  end

  context 'when property has a default' do
    # CollectionAccess.access has a default
    let(:access) { Cocina::Models::CollectionAccess.new }

    it 'default is provided' do
      expect(access.view).to eq 'dark'
    end
  end

  context 'when property is relaxed' do
    # Properties are relaxed when part of oneOf. This leaves the validation to openApi, rather than dry-struct.
    # Access.access and Access.location are constructed from a oneOf.
    let(:access) { Cocina::Models::Access.new(view: nil, location: 'my office') }

    it 'is not required and does not have enum' do
      expect(access.view).to be_nil
      expect(access.location).to eq('my office')
    end
  end

  context 'when property is cocinaVersion' do
    let(:dro) do
      Cocina::Models::RequestDRO.new({
                                       label: 'The Prince',
                                       type: Cocina::Models::ObjectType.book,
                                       version: 1,
                                       identification: { sourceId: 'sul:123' },
                                       administrative: { hasAdminPolicy: 'druid:bc123df4567' }
                                     }, false, false)
    end

    it 'default is provided' do
      expect(dro.cocinaVersion).to eq(Cocina::Models::VERSION)
    end
  end
end
