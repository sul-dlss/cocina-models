# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Cocina --> MODS mappings for form (H3 specific)' do
  # Mapping of Self deposit types and subtypes to genre and MODS type of resource:
  # https://docs.google.com/spreadsheets/d/1EiGgVqtb6PUJE2cI_jhqnAoiQkiwZtar4tF7NHwSMz8/edit?usp=sharing
  # H3>DataCite mapping: Data>Dataset, Image>Image, Mixed Materials>Collection, Music>Other,
  # Other>Other, Software/Code>Software, Sound>Sound, Text>Text, Video>Video
  # DataCite term always maps to resourceTypeGeneral
  # Self deposit subtype maps to resourceType
  # If multiple Self deposit subtypes, concatenate with semicolon space
  # If no Self deposit subtype, map Self deposit type to resourceType
  describe 'type only, resource type with URI' do
    # User enters type: Data, subtype: nil
    it_behaves_like 'cocina MODS mapping' do
      let(:cocina) do
        {
          form: [
            {
              structuredValue: [
                {
                  value: 'Data',
                  type: 'type'
                }
              ],
              source: {
                value: 'Stanford self-deposit resource types'
              },
              type: 'resource type'
            },
            {
              value: 'Data sets',
              type: 'genre',
              uri: 'https://id.loc.gov/authorities/genreForms/gf2018026119',
              source: {
                code: 'lcgft'
              }
            },
            {
              value: 'dataset',
              type: 'genre',
              source: {
                code: 'local'
              }
            },
            {
              value: 'Dataset',
              type: 'resource type',
              uri: 'http://id.loc.gov/vocabulary/resourceTypes/dat',
              source: {
                uri: 'http://id.loc.gov/vocabulary/resourceTypes/'
              }
            },
            {
              value: 'Dataset',
              type: 'resource type',
              source: {
                value: 'DataCite resource types'
              }
            }
          ]
        }
      end

      let(:mods) do
        <<~XML
          <genre type="Self deposit type">Data</genre>
          <typeOfResource authorityURI="http://id.loc.gov/vocabulary/resourceTypes/" valueURI="http://id.loc.gov/vocabulary/resourceTypes/dat">Dataset</typeOfResource>
          <genre authority="lcgft" valueURI="https://id.loc.gov/authorities/genreForms/gf2018026119">Data sets</genre>
          <genre authority="local">dataset</genre>
          <extension displayLabel="datacite">
            <resourceType resourceTypeGeneral="Dataset">Data</resourceType>
          </extension>
        XML
      end
    end
  end

  describe 'type with subtype' do
    # User enters type: Text, subtype: Article
    it_behaves_like 'cocina MODS mapping' do
      let(:cocina) do
        {
          form: [
            {
              structuredValue: [
                {
                  value: 'Text',
                  type: 'type'
                },
                {
                  value: 'Article',
                  type: 'subtype'
                }
              ],
              source: {
                value: 'Stanford self-deposit resource types'
              },
              type: 'resource type'
            },
            {
              value: 'text',
              type: 'resource type',
              source: {
                value: 'MODS resource types'
              }
            },
            {
              value: 'Text',
              type: 'resource type',
              source: {
                value: 'DataCite resource types'
              }
            }
          ]
        }
      end

      let(:mods) do
        <<~XML
          <genre type="Self deposit type">Text</genre>
          <genre type="Self deposit subtype">Article</genre>
          <typeOfResource>text</typeOfResource>
          <extension displayLabel="datacite">
            <resourceType resourceTypeGeneral="Text">Article</resourceType>
          </extension>
        XML
      end
    end
  end

  describe 'type with multiple subtypes' do
    # User enters type: Software/Code, subtype: Code, Documentation
    it_behaves_like 'cocina MODS mapping' do
      let(:cocina) do
        {
          form: [
            {
              structuredValue: [
                {
                  value: 'Software/Code',
                  type: 'type'
                },
                {
                  value: 'Code',
                  type: 'subtype'
                },
                {
                  value: 'Documentation',
                  type: 'subtype'
                }
              ],
              source: {
                value: 'Stanford self-deposit resource types'
              },
              type: 'resource type'
            },
            {
              value: 'computer program',
              type: 'genre',
              uri: 'http://id.loc.gov/vocabulary/marcgt/com',
              source: {
                code: 'marcgt'
              }
            },
            {
              value: 'software, multimedia',
              type: 'resource type',
              source: {
                value: 'MODS resource types'
              }
            },
            {
              value: 'text',
              type: 'resource type',
              source: {
                value: 'MODS resource types'
              }
            },
            {
              value: 'Software',
              type: 'resource type',
              source: {
                value: 'DataCite resource types'
              }
            }
          ]
        }
      end

      let(:mods) do
        <<~XML
          <genre type="Self deposit type">Software/Code</genre>
          <genre type="Self deposit subtype">Code</genre>
          <genre type="Self deposit subtype">Documentation</genre>
          <typeOfResource>software, multimedia</typeOfResource>
          <genre authority="marcgt" valueURI="http://id.loc.gov/vocabulary/marcgt/com">computer program</genre>
          <typeOfResource>text</typeOfResource>
          <extension displayLabel="datacite">
            <resourceType resourceTypeGeneral="Software">Code; Documentation</resourceType>
          </extension>
        XML
      end
    end
  end

  describe 'type with user-entered subtype' do
    # User enters type: Other, subtype: Dance notation
    it_behaves_like 'cocina MODS mapping' do
      let(:cocina) do
        {
          form: [
            {
              structuredValue: [
                {
                  value: 'Other',
                  type: 'type'
                },
                {
                  value: 'Dance notation',
                  type: 'subtype'
                }
              ],
              source: {
                value: 'Stanford self-deposit resource types'
              },
              type: 'resource type'
            },
            {
              value: 'Other',
              type: 'resource type',
              source: {
                value: 'DataCite resource types'
              }
            }
          ]
        }
      end

      let(:mods) do
        <<~XML
          <genre type="Self deposit type">Other</genre>
          <genre type="Self deposit subtype">Dance notation</genre>
          <extension displayLabel="datacite">
            <resourceType resourceTypeGeneral="Other">Dance notation</resourceType>
          </extension>
        XML
      end
    end
  end
end
