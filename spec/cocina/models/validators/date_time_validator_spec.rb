# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Validators::DateTimeValidator do
  subject(:validate) { described_class.validate(clazz, props) }

  let(:clazz) { Cocina::Models::DRO }

  context 'when attributes include description' do
    context 'when no dates present' do
      let(:props) do
        {
          description: {
            purl: 'https://purl.stanford.edu/jq000jd3530'
          }
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when no dates of validatable type present' do
      let(:props) do
        {
          description: {
            event: [
              {
                date: [
                  {
                    value: '2021',
                    type: 'copyright',
                    encoding: {
                      code: 'marc'
                    }
                  }
                ]
              }
            ]
          }
        }
      end

      it 'does not raise' do
        expect { validate }.not_to raise_error
      end
    end

    context 'when dates of validatable type present' do
      [
        # Common cases
        ['edtf', '2022', true],
        ['edtf', '1997-07', true],
        ['edtf', '1997-07-16', true],
        ['edtf', '1997-07-16T19:20', false],
        ['edtf', '1997-07-16T19:20:30', true],
        ['edtf', '1997-07-16T19:20:30.45', false],
        ['edtf', '1997-07-16T19:20+01:00', false],
        ['edtf', '1997-07-16T19:20:30+01:00', true],
        ['edtf', '1997-07-16T19:20:30.45+01:00', false],
        ['iso8601', '2022', true],
        ['iso8601', '1997-07', true],
        ['iso8601', '1997-07-16', true],
        ['iso8601', '1997-07-16T19:20', true],
        ['iso8601', '1997-07-16T19:20:30', true],
        ['iso8601', '1997-07-16T19:20:30.45', true],
        ['iso8601', '1997-07-16T19:20+01:00', true],
        ['iso8601', '1997-07-16T19:20:30+01:00', true],
        ['iso8601', '1997-07-16T19:20:30.45+01:00', true],
        ['w3cdtf', '2022', true],
        ['w3cdtf', '1997-07', true],
        ['w3cdtf', '1997-07-16', true],
        ['w3cdtf', '1997-07-16T19:20', false],
        ['w3cdtf', '1997-07-16T19:20:30', false],
        ['w3cdtf', '1997-07-16T19:20:30.45', false],
        ['w3cdtf', '1997-07-16T19:20+01:00', true],
        ['w3cdtf', '1997-07-16T19:20:30+01:00', true],
        ['w3cdtf', '1997-07-16T19:20:30.45+01:00', true],
        # Type-specific cases
        ['edtf', '-3999', true],
        ['iso8601', '-3999', false],
        ['w3cdtf', '-3999', false],
        ['edtf', 'Y-20555', true],
        ['edtf', 'Y20555', true],
        ['edtf', '0800', true],
        ['edtf', '800', true], # temporary exception for format violation
        ['edtf', '-800', true], # temporary exception for format violation
        ['edtf', '1', true], # temporary exception for format violation
        ['edtf', '20220608', false],
        ['edtf', '20220608T1204', false],
        ['edtf', '20220608T120435', false],
        ['edtf', '202206081204', false],
        ['edtf', '20220608120435', false],
        ['edtf', '20220608T120435.123', false],
        ['edtf', '20220608120435.123', false],
        ['iso8601', '20220608', true],
        ['iso8601', '20220608T1204', true],
        ['iso8601', '20220608T120435', true],
        ['iso8601', '202206081204', true],
        ['iso8601', '20220608120435', true],
        ['iso8601', '20220608T120435.123', true],
        ['iso8601', '20220608120435.123', true],
        ['w3cdtf', '20220608', false],
        ['w3cdtf', '20220608T1204', false],
        ['w3cdtf', '20220608T120435', false],
        ['w3cdtf', '202206081204', false],
        ['w3cdtf', '20220608120435', false],
        ['w3cdtf', '20220608T120435.123', false],
        ['w3cdtf', '20220608120435.123', false],
        ['w3cdtf', '1997-7', false],
        ['w3cdtf', '1997-00', false],
        ['w3cdtf', '1997-13', false],
        ['w3cdtf', '1997-1', false],
        ['w3cdtf', '1997-111', false]
      ].each do |code, value, valid|
        context "with #{valid ? 'valid' : 'invalid'} #{code} value #{value}" do
          let(:props) do
            {
              description: {
                event: [
                  {
                    date: [
                      {
                        value: value,
                        type: 'copyright',
                        encoding: {
                          code: code
                        }
                      }
                    ]
                  }
                ]
              }
            }
          end

          if valid
            it 'does not raise' do
              expect { validate }.not_to raise_error
            end
          else
            it 'raises' do
              expect { validate }.to raise_error(Cocina::Models::ValidationError)
            end
          end
        end
      end
    end

    # NOTE: the intent of this test is to show that the validator correctly
    #       navigates the structure and picks out the right bits as invalid
    context 'when highly nested' do
      let(:props) do
        {
          description: {
            event: [
              {
                date: [
                  {
                    parallelValue: [
                      {
                        structuredValue: [
                          {
                            value: '1996b',
                            type: 'start'
                          },
                          {
                            value: '1998a',
                            type: 'end'
                          }
                        ],
                        encoding: {
                          code: 'iso8601'
                        }
                      },
                      {
                        structuredValue: [
                          {
                            value: '4081',
                            type: 'start'
                          },
                          {
                            value: '4083z',
                            type: 'end'
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            ]
          }
        }
      end

      it 'raises' do
        expect { validate }.to raise_error(
          Cocina::Models::ValidationError,
          /\["1996b", "1998a", "iso8601"\]/
        )
      end
    end

    # NOTE: the intent of this test is to show that the validator correctly
    #       navigates the structure and picks out the right bits as invalid
    context 'when mix of structured and basic' do
      let(:props) do
        {
          description: {
            event: [
              {
                date: [
                  {
                    structuredValue: [
                      {
                        value: '1800',
                        type: 'start'
                      },
                      {
                        value: '1850z',
                        type: 'end'
                      }
                    ],
                    encoding: {
                      code: 'iso8601'
                    }
                  },
                  {
                    value: '1875y',
                    encoding: {
                      code: 'iso8601'
                    }
                  }
                ]
              }
            ]
          }
        }
      end

      it 'raises' do
        expect { validate }.to raise_error(
          Cocina::Models::ValidationError,
          /\["1850z", "iso8601"\], \["1875y", "iso8601"\]/
        )
      end
    end

    # NOTE: the intent of this test is to show that the validator correctly
    #       navigates the structure and picks out the right bits as invalid
    context 'with adminMetadata dates' do
      let(:props) do
        {
          description: {
            adminMetadata: {
              event: [
                {
                  type: 'creation',
                  date: [
                    {
                      value: '1803-05g',
                      encoding: {
                        code: 'iso8601'
                      }
                    }
                  ]
                },
                {
                  type: 'modification',
                  date: [
                    {
                      value: 'foo',
                      encoding: {
                        code: 'iso8601'
                      }
                    }
                  ]
                }
              ]
            }
          }

        }
      end

      it 'raises' do
        expect { validate }.to raise_error(
          Cocina::Models::ValidationError,
          /\["1803-05g", "iso8601"\], \["foo", "iso8601"\]/
        )
      end
    end
  end

  context 'when attributes lack description' do
    let(:props) { {} }

    it 'does not raise' do
      expect { validate }.not_to raise_error
    end
  end
end
