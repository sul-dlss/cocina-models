# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::MarcRelatorRoleValidator do
  let(:clazz) { Cocina::Models::Description }
  let(:validate) { described_class.validate(clazz, props) }

  let(:marc_relator_source) do
    { code: 'marcrelator', uri: 'http://id.loc.gov/vocabulary/relators/' }
  end

  describe '#validate' do
    context 'when no contributors' do
      let(:props) { { title: [{ value: 'A title' }] } }

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when contributor has no role' do
      let(:props) do
        {
          contributor: [
            { name: [{ value: 'Smith, John' }] }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when role has no code' do
      let(:props) do
        {
          contributor: [
            {
              role: [
                { value: 'author', source: marc_relator_source }
              ]
            }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when role has a valid marcrelator code identified by source code' do
      let(:props) do
        {
          contributor: [
            {
              role: [
                { value: 'author', code: 'aut', source: { code: 'marcrelator' } }
              ]
            }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when role has a valid marcrelator code identified by source URI' do
      let(:props) do
        {
          contributor: [
            {
              role: [
                { value: 'author', code: 'aut', source: { uri: 'http://id.loc.gov/vocabulary/relators/' } }
              ]
            }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when role has a discontinued marcrelator code' do
      let(:props) do
        {
          contributor: [
            {
              role: [
                # 'voc' (vocalist) is discontinued but must still be accepted
                { value: 'vocalist', code: 'voc', source: marc_relator_source }
              ]
            }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when role has an invalid marcrelator code' do
      let(:props) do
        {
          contributor: [
            {
              role: [
                { value: 'author', code: 'xyz', source: marc_relator_source }
              ]
            }
          ]
        }
      end

      it 'raises a ValidationError' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError,
                                           /contributor1\.role1 \(xyz\)/)
      end
    end

    context 'when role source is not marcrelator' do
      let(:props) do
        {
          contributor: [
            {
              role: [
                { value: 'author', code: 'xyz', source: { code: 'lcdgt' } }
              ]
            }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when role has no source' do
      let(:props) do
        {
          contributor: [
            {
              role: [
                { value: 'author', code: 'xyz' }
              ]
            }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when multiple contributors and roles with one bad code' do
      let(:props) do
        {
          contributor: [
            {
              role: [
                { value: 'author', code: 'aut', source: marc_relator_source },
                { value: 'editor', code: 'edt', source: marc_relator_source }
              ]
            },
            {
              role: [
                { value: 'bad', code: 'xyz', source: marc_relator_source }
              ]
            }
          ]
        }
      end

      it 'raises a ValidationError naming the specific path' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError,
                                           /contributor2\.role1 \(xyz\)/)
      end
    end

    context 'when relatedResource contributor role has an invalid code' do
      let(:props) do
        {
          contributor: [],
          relatedResource: [
            {
              contributor: [
                {
                  role: [
                    { value: 'bad', code: 'xyz', source: marc_relator_source }
                  ]
                }
              ]
            }
          ]
        }
      end

      it 'raises a ValidationError' do
        expect { validate }.to raise_error(Cocina::Models::ValidationError,
                                           /contributor1\.role1 \(xyz\)/)
      end
    end

    context 'when clazz is not Description or RequestDescription' do
      let(:clazz) { Cocina::Models::DRO }
      let(:props) do
        {
          contributor: [
            {
              role: [
                { value: 'bad', code: 'xyz', source: marc_relator_source }
              ]
            }
          ]
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end
  end
end
