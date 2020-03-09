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
  let(:admin_policy_default_rights) { Cocina::Models::AdminPolicy::Administrative::DEFAULT_OBJECT_RIGHTS }

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
        expect(admin_policy.access).to be_kind_of(Cocina::Models::AdminPolicy::Access)
        expect(admin_policy.access.attributes.size).to eq 0

        expect(admin_policy.administrative).to be_kind_of(Cocina::Models::AdminPolicy::Administrative)
        expect(admin_policy.administrative.default_object_rights).to eq admin_policy_default_rights
        expect(admin_policy.administrative.registration_workflow).to be_nil
        expect(admin_policy.administrative.hasAdminPolicy).to be_nil

        expect(admin_policy.identification).to be_kind_of(Cocina::Models::AdminPolicy::Identification)
        expect(admin_policy.identification.attributes.size).to eq 0

        expect(admin_policy.structural).to be_kind_of(Cocina::Models::AdminPolicy::Structural)
        expect(admin_policy.structural.attributes.size).to eq 0
      end
    end

    context 'with all specifiable properties' do
      let(:properties) do
        required_properties.merge(
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
        )
      end

      it 'populates all attributes passed in' do
        expect(admin_policy.administrative.hasAdminPolicy).to eq 'druid:mx123cd4567'
        expect(admin_policy.administrative.default_object_rights).to eq '<rightsMetadata></rightsMetadata>'
        expect(admin_policy.administrative.registration_workflow).to eq 'wasCrawlPreassemblyWF'

        expect(admin_policy.description.title.first.attributes).to eq(primary: true,
                                                                      titleFull: 'My admin_policy')
      end
    end

    context 'with empty optional properties that have default values' do
      let(:properties) { required_properties.merge(administrative: nil) }

      it 'uses default values' do
        expect(admin_policy.administrative).to be_kind_of(Cocina::Models::AdminPolicy::Administrative)
        expect(admin_policy.administrative.default_object_rights).to eq admin_policy_default_rights
        expect(admin_policy.administrative.registration_workflow).to be_nil
        expect(admin_policy.administrative.hasAdminPolicy).to be_nil
      end
    end
  end
end
