# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/admin_policy_shared_examples.rb'

RSpec.describe Cocina::Models::RequestAdminPolicy do
  let(:type) { Cocina::Models::Vocab.admin_policy }
  let(:required_properties) do
    {
      type: type,
      label: 'My admin_policy',
      version: 3,
      administrative: {}
    }
  end

  it_behaves_like 'it has admin_policy attributes'
end
