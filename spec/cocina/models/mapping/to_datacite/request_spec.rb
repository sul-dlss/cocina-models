# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Cocina::Models::Mapping::ToDatacite::Request do
  let(:request) { described_class.build(cocina_object:) }
  let(:cocina_object) do
    Cocina::Models::DRO.new(externalIdentifier: druid,
                            type: Cocina::Models::ObjectType.object,
                            label: label,
                            version: 1,
                            description: {
                              contributor: [
                                {
                                  name: [
                                    {
                                      value: 'National Institute of Health'
                                    }
                                  ],
                                  type: 'organization',
                                  status: 'primary',
                                  role: [
                                    {
                                      value: 'Funder',
                                      source: {
                                        value: 'H2 contributor role terms'
                                      }
                                    },
                                    {
                                      value: 'funder',
                                      code: 'fnd',
                                      uri: 'http://id.loc.gov/vocabulary/relators/fnd',
                                      source: {
                                        code: 'marcrelator',
                                        uri: 'http://id.loc.gov/vocabulary/relators/'
                                      }
                                    }
                                  ]
                                },
                                {
                                  name: [
                                    {
                                      structuredValue: [
                                        {
                                          value: 'Jane',
                                          type: 'forename'
                                        },
                                        {
                                          value: 'Stanford',
                                          type: 'surname'
                                        }
                                      ]
                                    }
                                  ],
                                  type: 'person',
                                  role: [
                                    {
                                      value: 'Author',
                                      source: {
                                        value: 'H2 contributor role terms'
                                      }
                                    },
                                    {
                                      value: 'author',
                                      code: 'aut',
                                      uri: 'http://id.loc.gov/vocabulary/relators/aut',
                                      source: {
                                        code: 'marcrelator',
                                        uri: 'http://id.loc.gov/vocabulary/relators/'
                                      }
                                    }
                                  ],
                                  affiliation: [
                                    {
                                      structuredValue: [
                                        {
                                          value: 'Stanford University',
                                          identifier: [
                                            {
                                              uri: 'https://ror.org/00f54p054',
                                              type: 'ROR',
                                              source: {
                                                code: 'ror'
                                              }
                                            }
                                          ]
                                        },
                                        {
                                          value: 'Woods Institute for the Environment'
                                        }
                                      ]
                                    }
                                  ],
                                  note: [
                                    {
                                      type: 'citation status',
                                      value: 'false'
                                    }
                                  ]
                                },
                                {
                                  name: [
                                    {
                                      structuredValue: [
                                        {
                                          value: 'John',
                                          type: 'forename'
                                        },
                                        {
                                          value: 'Stanford',
                                          type: 'surname'
                                        }
                                      ]
                                    }
                                  ],
                                  type: 'person',
                                  role: [
                                    {
                                      value: 'Author',
                                      source: {
                                        value: 'H2 contributor role terms'
                                      }
                                    },
                                    {
                                      value: 'author',
                                      code: 'aut',
                                      uri: 'http://id.loc.gov/vocabulary/relators/aut',
                                      source: {
                                        code: 'marcrelator',
                                        uri: 'http://id.loc.gov/vocabulary/relators/'
                                      }
                                    }
                                  ],
                                  affiliation: [
                                    {
                                      value: 'Stanford University',
                                      identifier: [
                                        {
                                          uri: 'https://ror.org/00f54p054',
                                          type: 'ROR',
                                          source: {
                                            code: 'ror'
                                          }
                                        }
                                      ]
                                    }
                                  ],
                                  note: [
                                    {
                                      type: 'citation status',
                                      value: 'false'
                                    }
                                  ]
                                },
                                {
                                  name: [
                                    {
                                      structuredValue: [
                                        {
                                          value: 'Stanford University',
                                          identifier: [
                                            {
                                              type: 'ROR',
                                              uri: 'https://ror.org/00f54p054',
                                              source: {
                                                code: 'ror'
                                              }
                                            }
                                          ]
                                        },
                                        {
                                          value: 'Department of Animal Husbandry'
                                        }
                                      ]
                                    }
                                  ],
                                  type: 'organization',
                                  status: 'primary',
                                  role: [
                                    {
                                      value: 'degree granting institution',
                                      code: 'dgg',
                                      uri: 'http://id.loc.gov/vocabulary/relators/dgg',
                                      source: {
                                        code: 'marcrelator',
                                        uri: 'http://id.loc.gov/vocabulary/relators/'
                                      }
                                    }
                                  ],
                                  note: [
                                    {
                                      type: 'citation status',
                                      value: 'false'
                                    }
                                  ]
                                }
                              ],
                              form: [
                                {
                                  value: 'Dataset',
                                  type: 'resource type',
                                  uri: 'http://id.loc.gov/vocabulary/resourceTypes/dat',
                                  source: {
                                    uri: 'http://id.loc.gov/vocabulary/resourceTypes/'
                                  }
                                },
                                {
                                  value: 'Data sets',
                                  type: 'genre',
                                  uri: 'https://id.loc.gov/authorities/genreForms/gf2018026119',
                                  source: {
                                    code: 'lcgft'
                                  }
                                },
                                {
                                  value: 'dataset',
                                  type: 'genre',
                                  source: {
                                    code: 'local'
                                  }
                                },
                                {
                                  value: 'Dataset',
                                  type: 'resource type',
                                  source: {
                                    value: 'DataCite resource types'
                                  }
                                }
                              ],
                              identifier: [
                                {
                                  value: doi,
                                  type: 'DOI'
                                }
                              ],
                              note: [
                                {
                                  type: 'abstract',
                                  value: 'My paper is about dolphins.'
                                }
                              ],
                              purl: purl,
                              relatedResource: [
                                {
                                  note: [
                                    {
                                      value: 'Stanford University (Stanford, CA.). (2020). May 2020 dataset. yadda yadda.',
                                      type: 'preferred citation'
                                    }
                                  ]
                                },
                                {
                                  type: 'referenced by',
                                  dataCiteRelationType: 'IsReferencedBy',
                                  identifier: [
                                    {
                                      type: 'doi',
                                      uri: 'https://doi.org/10.1234/example.doi'
                                    }
                                  ]
                                },
                                {} # Blank will be removed.
                              ],
                              subject: [
                                {
                                  value: 'Marine biology',
                                  type: 'topic',
                                  uri: 'http://id.worldcat.org/fast/1009447',
                                  source: {
                                    code: 'fast',
                                    uri: 'http://id.worldcat.org/fast/'
                                  }
                                }
                              ],
                              title: [{ value: title }]
                            },
                            identification: {
                              sourceId: 'sul:8.559351',
                              doi: doi
                            },
                            access: {
                              license: 'https://creativecommons.org/publicdomain/mark/1.0/'
                            },
                            administrative: {
                              hasAdminPolicy: apo_druid
                            },
                            structural: {})
  end
  let(:druid) { 'druid:bb666bb1234' }
  let(:doi) { "10.25740/#{druid.split(':').last}" }
  let(:purl) { "https://purl.stanford.edu/#{druid.split(':').last}" }
  let(:label) { 'label' }
  let(:title) { 'title' }
  let(:apo_druid) { 'druid:pp000pp0000' }
  let(:url) { nil }

  it 'populates the attributes hash correctly' do # rubocop:disable RSpec/ExampleLength
    expect(request).to eq(
      {
        event: 'publish',
        url: 'https://purl.stanford.edu/bb666bb1234',
        identifiers: [
          {
            identifier: '10.25740/bb666bb1234',
            identifierType: 'DOI'
          }
        ],
        titles: [
          {
            title: 'title'
          }
        ],
        publisher: {
          name: 'Stanford Digital Repository'
        },
        publicationYear: '2025',
        subjects: [
          {
            subject: 'Marine biology',
            subjectScheme: 'fast',
            valueUri: 'http://id.worldcat.org/fast/1009447',
            schemeUri: 'http://id.worldcat.org/fast/'
          }
        ],
        dates: [],
        language: 'en',
        types: {
          resourceTypeGeneral: 'Dataset',
          resourceType: ''
        },
        alternateIdentifiers: [
          {
            alternateIdentifier: purl,
            alternateIdentifierType: 'PURL'
          }
        ],
        relatedIdentifiers: [
          {
            resourceTypeGeneral: 'Other',
            relationType: 'IsReferencedBy',
            relatedIdentifier: 'https://doi.org/10.1234/example.doi',
            relatedIdentifierType: 'DOI'
          }
        ],
        rightsList: [
          {
            rightsUri: 'https://creativecommons.org/publicdomain/mark/1.0/'
          }
        ],
        descriptions: [
          {
            description: 'My paper is about dolphins.',
            descriptionType: 'Abstract'
          }
        ],
        relatedItems: [
          {
            relatedItemType: 'Other',
            relationType: 'References',
            titles: [
              {
                title: 'Stanford University (Stanford, CA.). (2020). May 2020 dataset. yadda yadda.'
              }
            ]
          },
          {
            relatedItemType: 'Other',
            relationType: 'IsReferencedBy',
            titles: [
              {
                title: 'https://doi.org/10.1234/example.doi'
              }
            ],
            relatedItemIdentifier: {
              relatedItemIdentifier: 'https://doi.org/10.1234/example.doi',
              relatedItemIdentifierType: 'DOI'
            }
          }
        ],
        creators: [
          {
            name: 'Stanford, Jane',
            givenName: 'Jane',
            familyName: 'Stanford',
            nameType: 'Personal',
            affiliation: [
              {
                affiliationIdentifier: 'https://ror.org/00f54p054',
                affiliationIdentifierScheme: 'ROR',
                name: 'Stanford University',
                schemeUri: 'https://ror.org/'
              }
            ]
          },
          {
            name: 'Stanford, John',
            givenName: 'John',
            familyName: 'Stanford',
            nameType: 'Personal',
            affiliation: [
              {
                affiliationIdentifier: 'https://ror.org/00f54p054',
                affiliationIdentifierScheme: 'ROR',
                name: 'Stanford University',
                schemeUri: 'https://ror.org/'
              }
            ]
          },
          {
            name: 'Stanford University',
            nameType: 'Organizational',
            nameIdentifiers: [
              {
                nameIdentifier: 'https://ror.org/00f54p054',
                nameIdentifierScheme: 'ROR'
              }
            ]
          }
        ],
        contributors: [],
        fundingReferences: [
          {
            funderName: 'National Institute of Health'
          }
        ]
      }
    )
  end
end
