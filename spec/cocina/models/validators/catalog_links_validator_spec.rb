# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::CatalogLinksValidator do
  subject(:validate) { described_class.validate(clazz, props) }

  {
    Cocina::Models::RequestDRO => Cocina::Models::ObjectType.book,
    Cocina::Models::DRO => Cocina::Models::ObjectType.object,
    Cocina::Models::DROWithMetadata => Cocina::Models::ObjectType.image,
    Cocina::Models::Collection => Cocina::Models::ObjectType.collection
  }.each do |clazz, type|
    context "with a #{clazz}" do
      let(:clazz) { clazz }
      let(:props) do
        {
          type: type,
          identification: {
            catalog_links: catalog_links
          }
        }
      end

      context 'with zero catalog links' do
        let(:catalog_links) { nil }

        it 'validates' do
          expect { validate }.not_to raise_error
        end
      end

      context 'with one refresh catalog link' do
        let(:catalog_links) do
          [
            {
              catalog: 'symphony',
              catalog_record_id: '111',
              refresh: true
            }
          ]
        end

        it 'validates' do
          expect { validate }.not_to raise_error
        end
      end

      context 'with one non-refresh catalog link' do
        let(:catalog_links) do
          [
            {
              catalog: 'symphony',
              catalog_record_id: '111',
              refresh: false
            }
          ]
        end

        it 'validates' do
          expect { validate }.not_to raise_error
        end
      end

      context 'with multiple non-refresh catalog links' do
        let(:catalog_links) do
          [
            {
              catalog: 'symphony',
              catalog_record_id: '111',
              refresh: false
            },
            {
              catalog: 'symphony',
              catalog_record_id: '222',
              refresh: false
            }
          ]
        end

        it 'validates' do
          expect { validate }.not_to raise_error
        end
      end

      context 'with multiple catalog links including one refresh' do
        let(:catalog_links) do
          [
            {
              catalog: 'symphony',
              catalog_record_id: '111',
              refresh: false
            },
            {
              catalog: 'symphony',
              catalog_record_id: '222',
              refresh: true
            }
          ]
        end

        it 'validates' do
          expect { validate }.not_to raise_error
        end
      end

      context 'with multiple catalog links including multiple refresh' do
        let(:catalog_links) do
          [
            {
              catalog: 'symphony',
              catalog_record_id: '111',
              refresh: true
            },
            {
              catalog: 'symphony',
              catalog_record_id: '222',
              refresh: true
            }
          ]
        end

        it 'raises a validation error' do
          expect { validate }.to raise_error(
            Cocina::Models::ValidationError,
            /Multiple catalog links have 'refresh' property set to true \(only one allowed\)/
          )
        end
      end
    end
  end

  context 'with a non-DRO/non-Collection' do
    let(:clazz) { Cocina::Models::AdminPolicy }
    let(:props) do
      {
        type: Cocina::Models::ObjectType.admin_policy
      }
    end

    it 'validates' do
      expect { validate }.not_to raise_error
    end
  end
end
