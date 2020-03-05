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
end
