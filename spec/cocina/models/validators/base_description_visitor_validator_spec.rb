# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::BaseDescriptionVisitorValidator do
  subject(:validator) { described_class.new }

  describe '#path_to_s' do
    subject(:result) { validator.path_to_s(path) }

    context 'with an empty path' do
      let(:path) { [] }

      it { is_expected.to eq('') }
    end

    context 'with a single string part' do
      let(:path) { ['title'] }

      it { is_expected.to eq('title') }
    end

    context 'with multiple string parts' do
      let(:path) { %w[contributor name] }

      it { is_expected.to eq('contributor.name') }
    end

    context 'with a string followed by an integer index' do
      let(:path) { ['title', 0] }

      # Integer indices are 1-based (to match spreadsheet rows)
      it { is_expected.to eq('title1') }
    end

    context 'with a string, integer, and nested string' do
      let(:path) { ['contributor', 0, 'name'] }

      it { is_expected.to eq('contributor1.name') }
    end

    context 'with multiple levels of nesting including several integers' do
      let(:path) { ['contributor', 1, 'identifier', 2, 'value'] }

      it { is_expected.to eq('contributor2.identifier3.value') }
    end

    context 'with a zero-based integer converted to 1-based' do
      let(:path) { ['relatedResource', 0] }

      it { is_expected.to eq('relatedResource1') }
    end

    context 'with deeply nested path' do
      let(:path) { ['relatedResource', 0, 'contributor', 0, 'name', 0, 'value'] }

      it { is_expected.to eq('relatedResource1.contributor1.name1.value') }
    end
  end
end
