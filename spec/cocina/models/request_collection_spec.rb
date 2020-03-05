# frozen_string_literal: true

require 'spec_helper'
load 'spec/cocina/models/collection_shared_examples.rb'

RSpec.describe Cocina::Models::RequestCollection do
  let(:collection_type) { Cocina::Models::Vocab.collection }
  let(:required_properties) do
    {
      type: collection_type,
      label: 'My collection',
      version: 3
    }
  end

  it_behaves_like 'it has collection attributes'
end
