# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Generator::SchemaRef do
  # This tests the outcome of running exe/generator generate against openapi.yml.
  context 'when referenced schema is required' do
    # AdminPolicy.administrative is a required AdminPolicyAdministrative
    context 'when provided' do
      let(:policy) do
        Cocina::Models::AdminPolicy.new({
                                          external_identifier: 'druid:bc123df4567',
                                          label: 'My admin policy',
                                          type: Cocina::Models::ObjectType.admin_policy,
                                          version: 1,
                                          administrative: {
                                            has_admin_policy: 'druid:bc123df4567',
                                            has_agreement: 'druid:bc123df4567'
                                          }
                                        }, false, false)
      end

      it 'handles required' do
        expect(policy.administrative).to be_kind_of(Cocina::Models::AdminPolicyAdministrative)
      end
    end

    context 'when not provided' do
      let(:policy) do
        Cocina::Models::AdminPolicy.new({
                                          external_identifier: 'druid:bc123df4567',
                                          label: 'My admin policy',
                                          type: Cocina::Models::ObjectType.admin_policy,
                                          version: 1
                                        }, false, false)
      end

      it 'raises an error' do
        expect { policy }.to raise_error(Dry::Struct::Error)
      end
    end
  end

  context 'when referenced schema is not required' do
    # AdminPolicy.description is an optional Description
    let(:policy) do
      Cocina::Models::AdminPolicy.new({
                                        external_identifier: 'druid:bc123df4567',
                                        label: 'My admin policy',
                                        type: Cocina::Models::ObjectType.admin_policy,
                                        version: 1,
                                        administrative: {
                                          has_admin_policy: 'druid:bc123df4567',
                                          has_agreement: 'druid:bc123df4567'
                                        }
                                      }, false, false)
    end

    it 'handles omittable' do
      expect(policy.description).to be_nil
    end
  end
end
