# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'MODS abstract <--> cocina mappings' do
  describe 'Single abstract' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <abstract>This is an abstract.</abstract>
        XML
      end

      let(:cocina) do
        {
          note: [
            {
              value: 'This is an abstract.',
              type: 'abstract'
            }
          ]
        }
      end
    end
  end

  describe 'Multilingual abstract' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <abstract lang='eng' script='Latn' altRepGroup='1'>This is an abstract.</abstract>
          <abstract lang='rus' script='Cyrl' altRepGroup='1'>Это аннотация.</abstract>
        XML
      end

      let(:cocina) do
        {
          note: [
            {
              type: 'abstract',
              parallelValue: [
                {
                  value: 'This is an abstract.',
                  valueLanguage: {
                    code: 'eng',
                    source: {
                      code: 'iso639-2b'
                    },
                    valueScript: {
                      code: 'Latn',
                      source: {
                        code: 'iso15924'
                      }
                    }
                  }
                },
                {
                  value: 'Это аннотация.',
                  valueLanguage: {
                    code: 'rus',
                    source: {
                      code: 'iso639-2b'
                    },
                    valueScript: {
                      code: 'Cyrl',
                      source: {
                        code: 'iso15924'
                      }
                    }
                  }
                }
              ]
            }
          ]
        }
      end
    end
  end

  describe 'Abstract with type' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <abstract type="summary">This is a summary.</abstract>
        XML
      end

      let(:cocina) do
        {
          note: [
            {
              value: 'This is a summary.',
              type: 'summary'
            }
          ]
        }
      end
    end
  end

  describe 'Abstract with display label and type' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <abstract displayLabel='Synopsis'>This is a synopsis.</abstract>
        XML
      end

      let(:cocina) do
        {
          note: [
            {
              value: 'This is a synopsis.',
              type: 'abstract',
              displayLabel: 'Synopsis'
            }
          ]
        }
      end
    end
  end

  describe 'Abstract with displayLabel and no type' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <abstract displayLabel="Summary">Summary</abstract>
        XML
      end

      let(:cocina) do
        {
          note: [
            {
              value: 'Summary',
              displayLabel: 'Summary'
            }
          ]
        }
      end
    end
  end

  describe 'Link to external value only' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <abstract xlink:href="http://hereistheabstract.com" />
        XML
      end

      let(:cocina) do
        {
          note: [
            {
              valueAt: 'http://hereistheabstract.com',
              type: 'abstract'
            }
          ]
        }
      end
    end
  end
end
