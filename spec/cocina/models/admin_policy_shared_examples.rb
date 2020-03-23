# frozen_string_literal: true

require 'spec_helper'

# These shared_examples are meant to be used by AdminPolicy and RequestAdminPolicy specs in
# order to de-dup test code for all the functionality they have in common.
# The caller must define required_properties as a hash containing
#   the minimal required properties that must be provided to (Request)AdminPolicy.new
RSpec.shared_examples 'it has admin_policy attributes' do
  let(:admin_policy) { described_class.new(properties) }
  let(:type) { Cocina::Models::Vocab.admin_policy }
  # see block comment for info about required_properties
  let(:properties) { required_properties }
  # rubocop:disable Metrics/LineLength
  let(:admin_policy_default_rights) { '<?xml version="1.0" encoding="UTF-8"?><rightsMetadata><access type="discover"><machine><world/></machine></access><access type="read"><machine><world/></machine></access><use><human type="useAndReproduction"/><human type="creativeCommons"/><machine type="creativeCommons" uri=""/><human type="openDataCommons"/><machine type="openDataCommons" uri=""/></use><copyright><human/></copyright></rightsMetadata>' }
  # rubocop:enable Metrics/LineLength

  describe 'initialization' do
    context 'with minimal required properties provided' do
      it 'populates required attributes passed in' do
        if required_properties[:externalIdentifier]
          expect(admin_policy.externalIdentifier).to eq required_properties[:externalIdentifier]
        end
        expect(admin_policy.label).to eq required_properties[:label]
        expect(admin_policy.type).to eq required_properties[:type]
        expect(admin_policy.version).to eq required_properties[:version]
      end

      it 'populates non-passed required attributes with default values' do
        expect(admin_policy.administrative).to be_kind_of(Cocina::Models::AdminPolicyAdministrative)
        expect(admin_policy.administrative.defaultObjectRights).to eq admin_policy_default_rights
        expect(admin_policy.administrative.registrationWorkflow).to be_nil
        expect(admin_policy.administrative.hasAdminPolicy).to be_nil
      end
    end

    context 'with all specifiable properties' do
      let(:properties) do
        required_properties.merge(
          administrative: {
            defaultObjectRights: '<rightsMetadata></rightsMetadata>',
            registrationWorkflow: 'wasCrawlPreassemblyWF',
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
        )
      end

      it 'populates all attributes passed in' do
        expect(admin_policy.administrative.hasAdminPolicy).to eq 'druid:mx123cd4567'
        expect(admin_policy.administrative.defaultObjectRights).to eq '<rightsMetadata></rightsMetadata>'
        expect(admin_policy.administrative.registrationWorkflow).to eq 'wasCrawlPreassemblyWF'

        expect(admin_policy.description.title.first.attributes).to eq(primary: true,
                                                                      titleFull: 'My admin_policy')
      end
    end
  end
end
