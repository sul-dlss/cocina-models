# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'MODS subject occupation <--> cocina mappings' do
  describe 'Subject with occupation subelement' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <subject>
            <occupation>Typesetters</occupation>
          </subject>
        XML
      end

      let(:cocina) do
        {
          subject: [
            {
              value: 'Typesetters',
              type: 'occupation'
            }
          ]
        }
      end
    end
  end
end
