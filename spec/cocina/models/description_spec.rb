# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Description do
  let(:item) { described_class.new(properties) }

  context 'with an etd' do
    let(:properties) { JSON.parse(File.read('spec/fixtures/description/etd.json')) }

    it 'populates attributes passed in' do
      title = item.title.first
      expect(title.value).to eq('Essays on Game Theory and Corporate Finance')
      expect(title.status).to eq('primary')

      expect(item.contributor.size).to eq(4)
      contributor = item.contributor.first

      name_value = contributor.name.first
      expect(name_value.value).to eq('Kasahara, Akitada, Jr')
      expect(name_value.type).to eq('inverted name')

      structured_name_value = contributor.name[1].structuredValue
      expect(structured_name_value.size).to eq(2)
      expect(structured_name_value.first.value).to eq('Kasahara, Akitada')
      expect(structured_name_value.first.type).to eq('inverted name')

      expect(contributor.type).to eq('person')
      expect(contributor.status).to eq('primary')

      expect(contributor.role.size).to eq(2)
      role = contributor.role.first
      expect(role.value).to eq('author')
      expect(role.code).to eq('aut')
      expect(role.uri).to eq('http://id.loc.gov/vocabulary/relators/aut')
      expect(role.source.code).to eq('marcrelator')
      expect(role.source.uri).to eq('http://id.loc.gov/vocabulary/relators/')

      expect(item.event.size).to eq(4)
      event = item.event.first
      expect(event.type).to eq('thesis submission')
      expect(event.date.first.value).to eq('2017')
      expect(event.contributor.size).to eq(1)

      expect(item.form.size).to eq(6)
      form = item.form.first
      expect(form.value).to eq('computer')
      expect(form.type).to eq('media')
      expect(form.uri).to eq('http://id.loc.gov/vocabulary/mediaTypes/c')
      expect(form.source.code).to eq('rdamedia')
      expect(form.source.uri).to eq('http://id.loc.gov/vocabulary/mediaTypes/')

      language = item.language.first
      expect(language.value).to eq('English')
      expect(language.code).to eq('eng')
      expect(language.uri).to eq('http://id.loc.gov/vocabulary/iso639-2/eng')
      expect(language.source.code).to eq('iso239-2b')
      expect(language.source.uri).to eq('http://id.loc.gov/vocabulary/iso639-2')

      expect(item.note.size).to eq(4)
      note = item.note.first
      expect(note.value).to match(/My dissertation is a combination of three papers/)
      expect(note.type).to eq('summary')

      identifier = item.identifier.first
      expect(identifier.value).to eq('0000005406')
      expect(identifier.type).to eq('ETD ID')

      expect(item.purl).to eq('http://purl.stanford.edu/hj456dt5655')

      url = item.access.url.first
      expect(url.value).to eq('https://etd.stanford.edu/view/0000005406')
      expect(url.type).to eq('ETD')

      expect(item.marcEncodedData.size).to eq(5)
      marc = item.marcEncodedData.first
      expect(marc.value).to eq('     nam a       3i')
      expect(marc.type).to eq('leader')

      expect(item.adminMetadata.event.size).to eq(2)
      expect(item.adminMetadata.contributor.size).to eq(3)
      expect(item.adminMetadata.language.size).to eq(1)
    end
  end

  context 'with another etd' do
    let(:properties) { JSON.parse(File.read('spec/fixtures/description/etd2.json')) }

    it 'populates attributes passed in' do
      title = item.title.first
      expect(title.value).to eq('Adaptive Guidance for Online Learning Environments')
      expect(title.status).to eq('primary')
    end
  end
end
