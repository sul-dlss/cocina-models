# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'MODS originInfo <--> cocina mappings' do
  describe 'Edition' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo>
            <edition>1st ed.</edition>
          </originInfo>
        XML
      end

      let(:cocina) do
        {
          event: [
            {
              note: [
                {
                  value: '1st ed.',
                  type: 'edition'
                }
              ]
            }
          ]
        }
      end
    end
  end

  describe 'Issuance and frequency' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo>
            <issuance>serial</issuance>
            <frequency>every full moon</frequency>
          </originInfo>
        XML
      end

      let(:cocina) do
        {
          event: [
            {
              note: [
                {
                  value: 'serial',
                  type: 'issuance',
                  source: {
                    value: 'MODS issuance terms'
                  }
                },
                {
                  value: 'every full moon',
                  type: 'frequency'
                }
              ]
            }
          ]
        }
      end
    end
  end

  describe 'Issuance and frequency - authorized term' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo>
            <issuance>multipart monograph</issuance>
            <frequency authority="marcfrequency">Annual</frequency>
          </originInfo>
        XML
      end

      let(:cocina) do
        {
          event: [
            {
              note: [
                {
                  value: 'multipart monograph',
                  type: 'issuance',
                  source: {
                    value: 'MODS issuance terms'
                  }
                },
                {
                  value: 'Annual',
                  type: 'frequency',
                  source: {
                    code: 'marcfrequency'
                  }
                }
              ]
            }
          ]
        }
      end
    end
  end

  describe 'Multiple originInfo elements with different event types' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo eventType="production">
            <dateCreated>1899</dateCreated>
            <place>
              <placeTerm type="text">York</placeTerm>
            </place>
          </originInfo>
          <originInfo eventType="publication">
            <dateIssued>1901</dateIssued>
            <place>
              <placeTerm type="text">London</placeTerm>
            </place>
          </originInfo>
        XML
      end

      let(:cocina) do
        {
          event: [
            {
              type: 'production',
              date: [
                {
                  value: '1899',
                  type: 'creation'
                }
              ],
              location: [
                {
                  value: 'York'
                }
              ]
            },
            {
              type: 'publication',
              date: [
                {
                  value: '1901',
                  type: 'publication'
                }
              ],
              location: [
                {
                  value: 'London'
                }
              ]
            }
          ]
        }
      end
    end
  end

  describe 'Multiple originInfo elements with and without event types' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo>
            <dateCreated>1899</dateCreated>
            <place>
              <placeTerm type="text">York</placeTerm>
            </place>
          </originInfo>
          <originInfo eventType="publication">
            <dateIssued>1901</dateIssued>
            <place>
              <placeTerm type="text">London</placeTerm>
            </place>
          </originInfo>
        XML
      end

      let(:cocina) do
        {
          event: [
            {
              date: [
                {
                  value: '1899',
                  type: 'creation'
                }
              ],
              location: [
                {
                  value: 'York'
                }
              ]
            },
            {
              type: 'publication',
              date: [
                {
                  value: '1901',
                  type: 'publication'
                }
              ],
              location: [
                {
                  value: 'London'
                }
              ]
            }
          ]
        }
      end
    end
  end

  describe 'Converted from MARC record with multiple 264s' do
    # "copyright notice" maps to event.note
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo>
             <place>
                <placeTerm type="code" authority="marccountry">ru</placeTerm>
             </place>
             <dateIssued encoding="marc">2019</dateIssued>
             <copyrightDate encoding="marc">2018</copyrightDate>
             <issuance>monographic</issuance>
          </originInfo>
          <originInfo eventType="publication">
             <place>
                <placeTerm type="text">Moskva</placeTerm>
             </place>
             <publisher>Izdatelʹstvo "Vesʹ Mir"</publisher>
             <dateIssued>2019</dateIssued>
          </originInfo>
          <originInfo eventType="copyright notice">
             <copyrightDate>©2018</copyrightDate>
          </originInfo>
        XML
      end

      let(:cocina) do
        {
          event: [
            {
              location: [
                {
                  code: 'ru',
                  source: {
                    code: 'marccountry'
                  }
                }
              ],
              date: [
                {
                  value: '2019',
                  type: 'publication',
                  encoding: {
                    code: 'marc'
                  }
                },
                {
                  value: '2018',
                  type: 'copyright',
                  encoding: {
                    code: 'marc'
                  }
                }
              ],
              note: [
                {
                  value: 'monographic',
                  type: 'issuance',
                  source: {
                    value: 'MODS issuance terms'
                  }
                }
              ]
            },
            {
              type: 'publication',
              location: [
                {
                  value: 'Moskva'
                }
              ],
              contributor: [
                {
                  name: [
                    {
                      value: 'Izdatelʹstvo "Vesʹ Mir"'
                    }
                  ],
                  role: [
                    {
                      value: 'publisher',
                      code: 'pbl',
                      uri: 'http://id.loc.gov/vocabulary/relators/pbl',
                      source: {
                        code: 'marcrelator',
                        uri: 'http://id.loc.gov/vocabulary/relators/'
                      }
                    }
                  ],
                  type: 'organization'
                }
              ],
              date: [
                {
                  value: '2019',
                  type: 'publication'
                }
              ]
            },
            {
              type: 'copyright notice',
              note: [
                {
                  value: '©2018',
                  type: 'copyright statement'
                }
              ]
            }
          ]
        }
      end
    end
  end

  describe 'originInfo with displayLabel' do
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo displayLabel="Origin" eventType="production">
            <place>
              <placeTerm type="text">Stanford (Calif.)</placeTerm>
            </place>
          </originInfo>
        XML
      end

      let(:cocina) do
        {
          event: [
            {
              type: 'production',
              displayLabel: 'Origin',
              location: [
                {
                  value: 'Stanford (Calif.)'
                }
              ]
            }
          ]
        }
      end
    end
  end

  # specs added by devs below

  context 'when originInfo / event is various flavors of empty/missing' do
    context 'when MODS has no elements' do
      it_behaves_like 'MODS cocina mapping' do
        let(:mods) { '' }

        let(:cocina) do
          {}
        end
      end
    end

    context 'when MODS is empty originInfo element with no attributes' do
      it_behaves_like 'MODS cocina mapping' do
        let(:mods) do
          <<~XML
            <originInfo/>
          XML
        end

        let(:roundtrip_mods) { '' }

        let(:cocina) do
          {}
        end
      end
    end

    context 'when MODS is a bunch of nothing based on actual record' do
      # based on qy796rh6653
      it_behaves_like 'MODS cocina mapping' do
        let(:mods) do
          <<~XML
            <originInfo eventType="production">
              <place>
                <placeTerm type="text"/>
              </place>
              <publisher/>
              <dateOther type="production"/>
            </originInfo>
          XML
        end

        let(:roundtrip_mods) { '' }

        let(:cocina) do
          {}
        end
      end
    end
  end

  context 'when two originInfos, one empty' do
    # based on qy796rh6653
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo>
            <place>
              <placeTerm authority="marccountry" type="code">xx</placeTerm>
            </place>
            <dateCreated encoding="marc">1990</dateCreated>
            <issuance>monographic</issuance>
          </originInfo>
          <originInfo eventType="production">
            <place>
              <placeTerm type="text"/>
            </place>
            <publisher/>
            <dateOther type="production"/>
          </originInfo>
        XML
      end

      let(:roundtrip_mods) do
        <<~XML
          <originInfo>
            <place>
              <placeTerm authority="marccountry" type="code">xx</placeTerm>
            </place>
            <dateCreated encoding="marc">1990</dateCreated>
            <issuance>monographic</issuance>
          </originInfo>
        XML
      end

      let(:cocina) do
        {
          event: [
            {
              location: [
                {
                  code: 'xx',
                  source: {
                    code: 'marccountry'
                  }
                }
              ],
              date: [
                {
                  value: '1990',
                  type: 'creation',
                  encoding: {
                    code: 'marc'
                  }
                }
              ],
              note: [
                {type: 'issuance',
                 value: 'monographic',
                 source: {
                   value: 'MODS issuance terms'
                 }}
              ]
            }
          ]
        }
      end
    end
  end

  describe 'unpaired altRepGroup' do
    # based on yz694pz8086

    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo script="Latn">
            <place>
              <placeTerm type="code" authority="marccountry">ja</placeTerm>
            </place>
            <dateIssued encoding="marc" point="start">1932</dateIssued>
            <dateIssued encoding="marc" point="end">1935</dateIssued>
            <issuance>monographic</issuance>
          </originInfo>
          <originInfo displayLabel="publisher" altRepGroup="04" script="Latn">
            <place>
              <placeTerm>[Tokyo] :</placeTerm>
            </place>
            <publisher>Dainihon Teikoku Rikuchi Sokuryōbu,</publisher>
            <dateIssued>Shōwa 7-10 [1932-1935]</dateIssued>
          </originInfo>
        XML
      end

      # second originInfo: legacy displayLabel becomes eventType; unmatched altRepGroup removed; placeTerm type text
      let(:roundtrip_mods) do
        <<~XML
          <originInfo script="Latn">
            <place>
              <placeTerm type="code" authority="marccountry">ja</placeTerm>
            </place>
            <dateIssued encoding="marc" point="start">1932</dateIssued>
            <dateIssued encoding="marc" point="end">1935</dateIssued>
            <issuance>monographic</issuance>
          </originInfo>
          <originInfo eventType="publication" script="Latn">
            <place>
              <placeTerm type="text">[Tokyo] :</placeTerm>
            </place>
            <publisher>Dainihon Teikoku Rikuchi Sokuryōbu,</publisher>
            <dateIssued>Shōwa 7-10 [1932-1935]</dateIssued>
          </originInfo>
        XML
      end

      let(:cocina) do
        {
          event: [
            {
              valueLanguage: {
                valueScript: {
                  code: 'Latn',
                  source: {
                    code: 'iso15924'
                  }
                }
              },
              location: [
                {
                  code: 'ja',
                  source: {
                    code: 'marccountry'
                  }
                }
              ],
              date: [
                {
                  structuredValue: [
                    {
                      value: '1932',
                      type: 'start'
                    },
                    {
                      value: '1935',
                      type: 'end'
                    }
                  ],
                  encoding: {
                    code: 'marc'
                  },
                  type: 'publication'
                }
              ],
              note: [
                {
                  value: 'monographic',
                  type: 'issuance',
                  source: {
                    value: 'MODS issuance terms'
                  }
                }
              ]
            },
            {
              type: 'publication',
              valueLanguage: {
                valueScript: {
                  code: 'Latn',
                  source: {
                    code: 'iso15924'
                  }
                }
              },
              location: [
                {
                  value: '[Tokyo] :'
                }
              ],
              contributor: [
                {
                  name: [
                    {
                      value: 'Dainihon Teikoku Rikuchi Sokuryōbu,'
                    }
                  ],
                  role: [
                    {
                      value: 'publisher',
                      code: 'pbl',
                      uri: 'http://id.loc.gov/vocabulary/relators/pbl',
                      source: {
                        code: 'marcrelator',
                        uri: 'http://id.loc.gov/vocabulary/relators/'
                      }
                    }
                  ],
                  type: 'organization'
                }
              ],
              date: [
                {
                  value: 'Shōwa 7-10 [1932-1935]',
                  type: 'publication'
                }
              ]
            }
          ]
        }
      end
    end
  end

  context 'when script tag without altRepGroup and no other originInfo' do
    # based on dt758gj8752, rt337mc1252 (which also have marc junk values - abbreviations! for Latin! for "unknown"!)

    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo script="Latn">
            <place>
              <placeTerm type="code" authority="marccountry">cc</placeTerm>
            </place>
            <place>
              <placeTerm type="text">[China</placeTerm>
            </place>
            <publisher>s.n.]</publisher>
          </originInfo>
        XML
      end

      # NOTE: valueLanguage for parallel script/lang - can be at originInfo or publisher
      let(:cocina) do
        {
          event: [
            {
              valueLanguage: {
                valueScript: {
                  code: 'Latn',
                  source: {
                    code: 'iso15924'
                  }
                }
              },
              location: [
                {
                  code: 'cc',
                  source: {
                    code: 'marccountry'
                  }
                },
                {
                  value: '[China'
                }
              ],
              contributor: [
                {
                  name: [
                    {
                      value: 's.n.]'
                    }
                  ],
                  role: [
                    {
                      value: 'publisher',
                      code: 'pbl',
                      uri: 'http://id.loc.gov/vocabulary/relators/pbl',
                      source: {
                        code: 'marcrelator',
                        uri: 'http://id.loc.gov/vocabulary/relators/'
                      }
                    }
                  ],
                  type: 'organization'
                }
              ]
            }
          ]
        }
      end
    end
  end

  context 'when empty placeTerm and empty date qualifier attribute' do
    # based on gh074sd3455, zp908qm7502
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo>
            <place>
              <placeTerm type="text"/>
            </place>
            <publisher></publisher>
            <dateIssued encoding="w3cdtf" keyDate="yes" qualifier="">1931</dateIssued>
          </originInfo>
        XML
      end

      let(:roundtrip_mods) do
        <<~XML
          <originInfo>
            <dateIssued encoding="w3cdtf" keyDate="yes">1931</dateIssued>
          </originInfo>
        XML
      end

      # should not have empty qualifier on date or location of nil or []
      let(:cocina) do
        {
          event: [
            {
              date: [
                {
                  value: '1931',
                  encoding: {
                    code: 'w3cdtf'
                  },
                  status: 'primary',
                  type: 'publication'
                }
              ]
            }
          ]
        }
      end
    end
  end

  context 'when empty placeTerm, dateOther with trailing period and legacy mods displayLabel' do
    # based on wm519yn6490, wm014gp0501
    it_behaves_like 'MODS cocina mapping' do
      let(:mods) do
        <<~XML
          <originInfo displayLabel="producer">
            <place>
              <placeTerm/>
            </place>
            <publisher/>
            <dateOther type="production">June 7, 1977.</dateOther>
          </originInfo>
        XML
      end

      let(:roundtrip_mods) do
        <<~XML
          <originInfo eventType='production'>
            <dateOther type="production">June 7, 1977</dateOther>
          </originInfo>
        XML
      end

      # should not have empty qualifier on date or location of nil or []
      let(:cocina) do
        {
          event: [
            {
              type: 'production',
              date: [
                {
                  value: 'June 7, 1977',
                  type: 'production'
                }
              ]
            }
          ]
        }
      end
    end
  end
end
