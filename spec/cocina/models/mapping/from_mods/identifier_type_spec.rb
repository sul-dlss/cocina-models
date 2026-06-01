# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Mapping::FromMods::IdentifierType do
  describe '.mods_type_for_cocina_type' do
    it 'returns the mapped mods type from standard identifier schemes' do
      expect(described_class.mods_type_for_cocina_type('ORCID')).to eq('orcid')
    end

    it 'returns the mapped mods type from standard identifier source codes' do
      expect(described_class.mods_type_for_cocina_type('ARK')).to eq('ark')
    end

    it 'falls back to the original cocina type when there is no mapping' do
      expect(described_class.mods_type_for_cocina_type('OCLC')).to eq('OCLC')
    end
  end
end
