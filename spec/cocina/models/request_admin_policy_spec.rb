# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/admin_policy_shared_examples.rb'

RSpec.describe Cocina::Models::RequestAdminPolicy do
  let(:type) { Cocina::Models::Vocab.admin_policy }
  let(:required_properties) do
    {
      type: type,
      label: 'My admin_policy',
      version: 3
    }
  end

  it_behaves_like 'it has admin_policy attributes'

  it 'does not have Checkable model methods' do
    item = described_class.new(required_properties)
    expect(item).not_to respond_to(:admin_policy?)
    expect(item).not_to respond_to(:collection?)
    expect(item).not_to respond_to(:dro?)
    expect(item).not_to respond_to(:file?)
    expect(item).not_to respond_to(:file_set?)
  end
end
