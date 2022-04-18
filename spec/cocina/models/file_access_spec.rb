# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::FileAccess do
  # Verifying that correctly validate access, download, location, and controlled_digital_lending.

  def dro(access, download, location, controlled_digital_lending)
    Cocina::Models::DRO.new(external_identifier: 'druid:bc123df4567',
                            label: 'My DRO',
                            type: Cocina::Models::ObjectType.book,
                            version: 1,
                            description: {
                              title: [{ value: 'Test DRO' }],
                              purl: 'https://purl.stanford.edu/bc123df4567'
                            },
                            administrative: { has_admin_policy: 'druid:bc123df4567' },
                            identification: { source_id: 'sul:123' },
                            access: {},
                            structural: {
                              contains: [
                                {
                                  version: 1,
                                  type: 'https://cocina.sul.stanford.edu/models/resources/file',
                                  label: 'Page 1',
                                  external_identifier: 'abc123',
                                  structural: {
                                    contains: [
                                      {
                                        version: 1,
                                        type: 'https://cocina.sul.stanford.edu/models/file',
                                        filename: '00002.jp2',
                                        label: '00002.jp2',
                                        has_mime_type: 'image/jp2',
                                        external_identifier: 'abc123',
                                        size: 111_467,
                                        administrative: {
                                          publish: true,
                                          sdr_preserve: true,
                                          shelve: true
                                        },
                                        access: {
                                          view: access,
                                          download: download,
                                          location: location,
                                          controlled_digital_lending: controlled_digital_lending
                                        },
                                        has_message_digests: []
                                      }
                                    ]
                                  }
                                }
                              ]
                            })
  end

  context 'with dark access' do
    it 'validates' do
      expect { dro('dark', 'none', nil, false) }.not_to raise_error
      expect { dro('dark', 'location-based', nil, false) }.to raise_error(Cocina::Models::ValidationError)
      expect { dro('dark', 'world', nil, false) }.to raise_error(Cocina::Models::ValidationError)
      expect { dro('dark', 'stanford', nil, false) }.to raise_error(Cocina::Models::ValidationError)
      expect { dro('dark', 'none', 'art', false) }.to raise_error(Cocina::Models::ValidationError)
      # Depends on https://github.com/ota42y/openapi_parser/pull/104
      # expect {dro('dark', 'none', nil, true) }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'with world access' do
    it 'validates' do
      expect { dro('world', 'world', nil, false) }.not_to raise_error
      expect { dro('world', 'stanford', nil, false) }.not_to raise_error
      expect { dro('world', 'none', nil, false) }.not_to raise_error
      expect { dro('world', 'location-based', 'art', false) }.not_to raise_error
      expect { dro('world', 'location-based', nil, false) }.to raise_error(Cocina::Models::ValidationError)
      # Depends on https://github.com/ota42y/openapi_parser/pull/104
      # expect {dro('world', 'world', nil, true) }.not_to raise_error
    end
  end

  context 'with stanford access' do
    it 'validates' do
      expect { dro('stanford', 'stanford', nil, false) }.not_to raise_error
      expect { dro('stanford', 'none', nil, false) }.not_to raise_error
      expect { dro('stanford', 'none', nil, true) }.not_to raise_error
      expect { dro('stanford', 'location-based', 'art', false) }.not_to raise_error
      expect { dro('stanford', 'location-based', nil, false) }.to raise_error(Cocina::Models::ValidationError)
      expect { dro('stanford', 'world', nil, false) }.to raise_error(Cocina::Models::ValidationError)
    end
  end

  context 'with location-based access' do
    it 'validates' do
      expect { dro('location-based', 'location-based', 'art', false) }.not_to raise_error
      expect { dro('location-based', 'location-based', nil, false) }
        .to raise_error(Cocina::Models::ValidationError)
      expect { dro('location-based', 'none', 'art', false) }.not_to raise_error
      expect { dro('location-based', 'none', nil, false) }.to raise_error(Cocina::Models::ValidationError)
      expect { dro('location-based', 'stanford', 'art', false) }.to raise_error(Cocina::Models::ValidationError)
      expect { dro('location-based', 'world', 'art', false) }.to raise_error(Cocina::Models::ValidationError)
      # Depends on https://github.com/ota42y/openapi_parser/pull/104
      # expect {dro('location-based', 'location-based', 'art', true) }
      #   .to raise_error(Cocina::Models::ValidationError)
    end
  end
end
