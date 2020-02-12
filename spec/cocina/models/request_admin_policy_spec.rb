# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::RequestAdminPolicy do
  subject(:admin_policy) { described_class.new(properties) }

  let(:type) { Cocina::Models::Vocab.admin_policy }

  describe 'initialization' do
    context 'with a minimal set' do
      let(:properties) do
        {
          type: type,
          label: 'My admin_policy',
          version: 3,
          description: {
            title: []
          }
        }
      end

      it 'has properties' do
        expect(admin_policy.type).to eq type
        expect(admin_policy.label).to eq 'My admin_policy'

        expect(admin_policy.access).to be_kind_of Cocina::Models::AdminPolicy::Access
      end
    end

    context 'with a string version' do
      let(:properties) do
        {
          type: type,
          label: 'My admin_policy',
          version: '3',
          description: {
            title: []
          }
        }
      end

      it 'coerces to integer' do
        expect(admin_policy.version).to eq 3
      end
    end

    context 'with all properties' do
      let(:properties) do
        {
          type: type,
          label: 'My admin_policy',
          version: 3,
          access: {
          },
          administrative: {
            default_object_rights: '<rightsMetadata></rightsMetadata>',
            registration_workflow: 'wasCrawlPreassemblyWF',
            hasAdminPolicy: 'druid:mx123cd4567'
          },
          description: {
            title: [
              {
                primary: true,
                titleFull: 'My admin_policy'
              }
            ]
          }
        }
      end

      it 'has properties' do
        expect(admin_policy.type).to eq type
        expect(admin_policy.label).to eq 'My admin_policy'
        expect(admin_policy.administrative.hasAdminPolicy).to eq 'druid:mx123cd4567'
        expect(admin_policy.administrative.default_object_rights).to eq '<rightsMetadata></rightsMetadata>'
        expect(admin_policy.administrative.registration_workflow).to eq 'wasCrawlPreassemblyWF'
      end
    end
  end

  describe '.from_dynamic' do
    subject(:admin_policy) { described_class.from_dynamic(properties) }

    context 'with empty subschemas' do
      let(:properties) do
        {
          'type' => type,
          'label' => 'Examination of the memorial of the owners and underwriters ...',
          'version' => 1,
          'access' => {},
          'administrative' => {
            'default_object_rights' => '<rightsMetadata></rightsMetadata>',
            'registration_workflow' => 'wasCrawlPreassemblyWF',
            'hasAdminPolicy' => 'druid:mx123cd4567'
          },
          'description' => {
            'title' => []
          },
          'identification' => {},
          'structural' => {}
        }
      end

      it 'has properties' do
        expect(admin_policy.label).to eq 'Examination of the memorial of the owners and underwriters ...'
        expect(admin_policy.administrative.hasAdminPolicy).to eq 'druid:mx123cd4567'
        expect(admin_policy.administrative.default_object_rights).to eq '<rightsMetadata></rightsMetadata>'
        expect(admin_policy.administrative.registration_workflow).to eq 'wasCrawlPreassemblyWF'
      end
    end
  end

  describe '.from_json' do
    subject(:admin_policy) { described_class.from_json(json) }

    context 'with a minimal admin_policy' do
      let(:json) do
        <<~JSON
          {
            "type":"#{type}",
            "label":"my admin_policy",
            "version": 3,
            "description": {
              "title": []
            }
          }
        JSON
      end

      it 'has the attributes' do
        expect(admin_policy.attributes).to include(label: 'my admin_policy',
                                                   type: type)
        expect(admin_policy.access).to be_kind_of Cocina::Models::AdminPolicy::Access
        expect(admin_policy.administrative).to be_kind_of Cocina::Models::AdminPolicy::Administrative
        expect(admin_policy.identification).to be_kind_of Cocina::Models::AdminPolicy::Identification
        expect(admin_policy.structural).to be_kind_of Cocina::Models::AdminPolicy::Structural
      end
    end

    context 'with a full admin_policy' do
      let(:json) do
        <<~JSON
          {
            "type":"#{type}",
            "label":"my admin_policy",
            "version": 3,
            "access": {
            },
            "administrative": {
              "default_object_rights":"<rightsMetadata></rightsMetadata>",
              "registration_workflow":"wasCrawlPreassemblyWF",
              "hasAdminPolicy":"druid:mx123cd4567"
            },
            "description": {
              "title": [
                {
                  "primary": true,
                  "titleFull":"my admin_policy"
                }
              ]
            }
          }
        JSON
      end

      it 'has the attributes' do
        expect(admin_policy.attributes).to include(label: 'my admin_policy',
                                                   type: type)

        expect(admin_policy.administrative).to be_kind_of Cocina::Models::AdminPolicy::Administrative
        expect(admin_policy.administrative.hasAdminPolicy).to eq 'druid:mx123cd4567'
        expect(admin_policy.description.title.first.attributes).to eq(primary: true,
                                                                      titleFull: 'my admin_policy')
      end
    end
  end
end
