# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::MapCoordinatesValidator do
  subject(:validate) { described_class.validate(clazz, props) }

  let(:clazz) { Cocina::Models::DRO }

  context 'when valid' do
    let(:props) do
      {
        externalIdentifier: 'druid:jq000jd3530',
        description: {
          subject: [
            {
              value: 'W 62°51ʹ00ʺ--W 62°04ʹ00ʺ--N 17°30ʹ20ʺ--N 16°32ʹ00ʺ',
              type: 'map coordinates'
            }
          ]
        }
      }
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when no subject with map coordinates' do
    let(:props) do
      {
        externalIdentifier: 'druid:jq000jd3530',
        description: {
          subject: [
            {
              value: 'Some info about this item.',
              type: 'abstract'
            }
          ]
        }
      }
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when out of bounds invalid coordinates' do
    let(:props) do
      {
        externalIdentifier: 'druid:xq000jd3530',
        description: {
          subject: [
            {
              value: '-W 450°00ʹ00ʺ--W -200°00ʹ00ʺ--N 150°00ʹ00ʺ--N 0°0ʹ00ʺ',
              type: 'map coordinates'
            }
          ]
        }
      }
    end

    it 'raises' do
      expect do
        validate
      end.to raise_error(
        Cocina::Models::ValidationError,
        'Invalid map coordinates for druid:xq000jd3530: -W 450°00ʹ00ʺ--W -200°00ʹ00ʺ--N 150°00ʹ00ʺ--N 0°0ʹ00ʺ'
      )
    end
  end

  context 'when extra characters in coordinates' do
    let(:props) do
      {
        externalIdentifier: 'druid:xq000jd3530',
        description: {
          subject: [
            {
              value: 'W 62°51ʹ00ʺ--W 62°04ʹ00ʺ--N 17°30ʹ20ʺ--N 16°32ʹ00ʺ).',
              type: 'map coordinates'
            }
          ]
        }
      }
    end

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end

  context 'when coordinates contains non-coordinate data' do
    let(:props) do
      {
        externalIdentifier: 'druid:xq000jd3530',
        description: {
          subject: [
            {
              value: 'W 62°51ʹ00ʺ--just kidding!!',
              type: 'map coordinates'
            }
          ]
        }
      }
    end

    it 'raises' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Invalid map coordinates for druid:xq000jd3530: W 62°51ʹ00ʺ--just kidding!!'
      )
    end
  end

  context 'when there are the wrong number of valid coordinates' do
    let(:props) do
      {
        externalIdentifier: 'druid:xq000jd3530',
        description: {
          subject: [
            {
              value: 'W 62°51ʹ00ʺ--W 62°04ʹ00ʺ--N 17°30ʹ20ʺ',
              type: 'map coordinates'
            }
          ]
        }
      }
    end

    it 'raises' do
      expect { validate }.to raise_error(
        Cocina::Models::ValidationError,
        'Invalid map coordinates for druid:xq000jd3530: W 62°51ʹ00ʺ--W 62°04ʹ00ʺ--N 17°30ʹ20ʺ'
      )
    end
  end
end
