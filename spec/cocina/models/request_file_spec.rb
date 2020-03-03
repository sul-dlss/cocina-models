# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/file_shared_examples.rb'

RSpec.describe Cocina::Models::RequestFile do
  let(:file_type) { 'http://cocina.sul.stanford.edu/models/file.jsonld' }
  let(:required_properties) do
    {
      label: 'My file',
      type: file_type,
      version: 3
    }
  end

  it_behaves_like 'it has file attributes'

  it 'does not have Checkable model methods' do
    item = described_class.new(required_properties)
    expect(item).not_to respond_to(:admin_policy?)
    expect(item).not_to respond_to(:collection?)
    expect(item).not_to respond_to(:dro?)
    expect(item).not_to respond_to(:file?)
    expect(item).not_to respond_to(:file_set?)
  end
end
