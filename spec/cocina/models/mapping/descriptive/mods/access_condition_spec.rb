# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'MODS accessCondition <--> cocina mappings' do
  describe 'Access condition with type' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <accessCondition type="restriction on access">Available to Stanford researchers only.</accessCondition>
        XML
      end

      let(:cocina) do
        {
          access: {
            note: [
              {
                value: 'Available to Stanford researchers only.',
                type: 'access restriction'
              }
            ]
          }
        }
      end
    end
  end

  describe 'Access condition without type' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <accessCondition>Available to Stanford researchers only.</accessCondition>
        XML
      end

      let(:cocina) do
        {
          access: {
            note: [
              {
                value: 'Available to Stanford researchers only.'
              }
            ]
          }
        }
      end
    end
  end

  describe 'Link to external value only' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <accessCondition xlink:href="http://accesscondition.org/accesscondition" />
        XML
      end

      let(:cocina) do
        {
          access: {
            note: [
              {
                valueAt: 'http://accesscondition.org/accesscondition'
              }
            ]
          }
        }
      end
    end
  end
end
