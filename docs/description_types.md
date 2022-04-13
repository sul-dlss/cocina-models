# Description types

## Access accesscontact types
_Path: access.accessContact_
  * email: Email address for a contact person or institution concerning the resource.
  * repository: Institution providing access to the resource.

## Access digitallocation types
_Path: access.digitalLocation_
  * discovery: Online location for the purpose of discovering the resource.

## Access note types
_Path: access.note_
  * access restriction: Restrictions on or conditions for gaining access to the resource.
  * display label: Display label for the purl.
  * license: License describing allowed uses of the resource.
  * use and reproduction: Information related to allowed uses of the resource in other contexts.

## Access physicallocation types
_Path: access.physicalLocation_
  * discovery: Location where a user may find the resource.
  * location: Physical location of the resource, or path to the resource on a hard drive or disk.
  * repository: The institution holding the resource.
  * series: Archival series of the resource.
  * shelf locator: Identifier or shelfmark indicating the location of the resource.

## Adminmetadata note types
_Path: adminMetadata.note_
  * record information: General information about the metadata record.
  * record origin: The source of the record, such as another record transformed to generate the current record.

# Contributor types
_Path: contributor_
  * conference: An event focusing on a particular topic or discipline.
  * event: A time-bound occurrence.
  * family: A group of individuals related by blood or personal alliance.
  * organization: An institution or other corporate or collective body.
  * person: An individual identity.
  * unspecified others: Designator for one or more additional contributors not named individually.

## Contributor identifier types
_Path: contributor.identifier_
  * ORCID: Identifier from orcid.org.
  * Wikidata: Identifier from wikidata.org.

## Contributor name types
_Path: contributor.name_
  * alternative: Additional nonpreferred form of name.
  * display: Preferred form of the name for display.
  * forename: First or given name or names.
  * inverted full name: Name given in last name, first name order.
  * pseudonym: Name used that differs from legal or primary form of name.
  * surname: Last or family name.
  * transliteration: Name originally in non-Latin script presented phonetically using Latin characters.

### Contributor name part types for structured value
_Path: contributor.name.structuredValue_
  * activity dates: The date or dates when someone was producing work.
  * forename: First or given name or names.
  * life dates: Birth and death dates, or dates when an entity was in existence.
  * name: Name provided alongside additional information.
  * ordinal: Indicator that the name is one in a series (e.g. Elizabeth I, Martin Luther King, Jr.).
  * surname: Last or family name.
  * term of address: Title or other signifier associated with name.

### Contributor name types for grouped value (MODS legacy)
_Path: contributor.name.groupedValue_
  * alternative: Additional nonpreferred form of name.
  * name: Primary form of name within group of values.
  * pseudonym: Name used that differs from legal or primary form of name.

## Contributor note types
_Path: contributor.note_
  * affiliation: Institution with which the contributor is associated.
  * citation status: Indicator of whether the contributor should be included in the citation.
  * description: Biographical information about the contributor.

# Event types
_Path: event_
  * acquisition: The transferral of ownership of a resource to a repository.
  * capture: A record of the resource in a fixed form at a specific time.
  * collection: The addition of a resource to a set of other resources.
  * copyright: The activity by which a resource may be considered subject to copyright law.
  * copyright notice: An explicit statement that a resource is under copyright.
  * creation: The coming into being of a resource.
  * degree conferral: The institutional approval of a thesis or other resource leading to an academic degree.
  * development: The creation of a print from a photographic negative or other source medium.
  * distribution: The delivery of the resource to an external audience.
  * generation: The creation of a resource by an automatic or natural process.
  * manufacture: The physical assembly of a resource, often in multiple copies, for publication or other distribution.
  * modification: A change to an existing resource.
  * performance: The enactment of an artistic or cultural work for an audience, such as a play.
  * presentation: The discussion of an academic or intellectual work for an audience, such as a seminar.
  * production: The physical assembly of a resource not considered published, such as page proofs for a book.
  * publication: The publishing or issuing of a resource.
  * recording: The initial fixation to a medium of live audio and/or visual activity.
  * release: Making a resource available to a broader audience.
  * submission: The provision of a resource for review or evaluation.
  * validity: When a resource takes effect, such as a revised train schedule.
  * withdrawal: The removal of previous access to a resource, often due to its obsolescence.

## Event date types
_Path: event.date_
  * acquisition: The transferral of ownership of a resource to a repository.
  * capture: A record of the resource in a fixed form at a specific time.
  * collection: The addition of a resource to a set of other resources.
  * copyright: The activity by which a resource may be considered subject to copyright law.
  * coverage
  * creation: The coming into being of a resource.
  * degree conferral: The institutional approval of a thesis or other resource leading to an academic degree.
  * developed: The creation of a print from a photographic negative or other source medium.
  * development: The creation of a print from a photographic negative or other source medium.
  * distribution: The delivery of the resource to an external audience.
  * generation: The creation of a resource by an automatic or natural process.
  * manufacture: The physical assembly of a resource, often in multiple copies, for publication or other distribution.
  * modification: A change to an existing resource.
  * performance: The enactment of an artistic or cultural work for an audience, such as a play.
  * presentation: The discussion of an academic or intellectual work for an audience, such as a seminar.
  * production: The physical assembly of a resource not considered published, such as page proofs for a book.
  * publication: The publishing or issuing of a resource.
  * recording: The initial fixation to a medium of live audio and/or visual activity.
  * release: Making a resource available to a broader audience.
  * submission: The provision of a resource for review or evaluation.
  * validity: When a resource takes effect, such as a revised train schedule.
  * withdrawal: The removal of previous access to a resource, often due to its obsolescence.

### Event date part types for structured value
_Path: event.date.structuredValue_
  * start: The start date in a range.
  * end: The end date in a range.

## Event note types
_Path: event.note_
  * copyright statement: A formal declaration of copyright on a resource.
  * edition
  * frequency: How often a resource is issued, such as monthly.
  * issuance: How the resource is issued, such as serially.

# Form types
_Path: form_
  * carrier
  * data format
  * digital origin
  * extent
  * form
  * genre
  * map projection
  * map scale
  * material
  * media
  * media type
  * reformatting quality
  * resource type
  * technique
  * type

## Form note types
_Path: form.note_
  * additions
  * arrangement
  * binding
  * codicology
  * collation
  * colophon
  * condition
  * decoNote
  * decoration
  * dimensions
  * explicit
  * foliation
  * genre type
  * hand note
  * handNote
  * incipit
  * instrumentation
  * layout
  * material
  * medium of performance
  * provenance
  * reassembly
  * reproduction
  * research
  * rubric
  * secfol
  * second folio
  * secondFolio
  * unit
  * writing

## Form part types for structured value
_Path: form.structuredValue_
  * type
  * subtype

## Geographic form types
_Path: geographic.form_
  * data format
  * media type
  * type

## Geographic subject types
_Path: geographic.subject_
  * bounding box coordinates
  * coverage
  * point coordinates

### Geographic subject part types for structured value
_Path: geographic.subject.structuredValue_
  * east
  * latitude
  * longitude
  * north
  * south
  * west

# Identifier types
_Path: identifier_
  * accession number
  * alternate case number
  * Apis ID
  * ARK
  * arXiv
  * case identifier
  * case number
  * CSt
  * CStRLIN
  * document number
  * DOI
  * druid
  * GTIN-14 ID
  * Handle
  * inventory number
  * ISBN
  * ISMN
  * ISRC
  * ISSN
  * ISSN-L
  * issue number
  * LCCN
  * local
  * Local ID
  * matrix number
  * music plate
  * music publisher
  * OCLC
  * OCoLC
  * PMCID
  * PMID
  * record id
  * Senate Number
  * Series
  * SIRSI
  * Source ID
  * sourceID
  * stock number
  * SUL catalog key
  * Swets (Netherlands) ID
  * UPC
  * URI
  * URN
  * videorecording identifier
  * West Mat \#
  * Wikidata

# Note types
_Path: note_
  * abstract
  * access
  * access note
  * acquisition
  * action
  * additional physical form
  * additions
  * admin
  * affiliation
  * bibliographic
  * bibliography
  * biographical/historical
  * biographical/historical note
  * biography
  * boat note
  * citation/reference
  * contact
  * content
  * content note
  * content warning
  * contents
  * copyright
  * creation/production credits
  * date
  * date/sequential designation
  * description
  * digitization
  * duration
  * event
  * exhibitions
  * funding
  * general
  * genre type
  * geography
  * host
  * language
  * local
  * location
  * medium of performance
  * names
  * numbering
  * original location
  * other relation type
  * ownership
  * part
  * performer
  * performers
  * preferred citation
  * provenance
  * publications
  * qualifications
  * quote
  * reassembly
  * reference
  * references
  * reformatting
  * related publication
  * reproduction
  * research
  * restriction
  * scope and content
  * source characteristics
  * source identifier
  * statement of responsibility
  * summary
  * system details
  * system requirements
  * table of contents
  * target audience
  * technical note
  * thesis
  * transcript
  * translation
  * update
  * use and reproduction
  * venue
  * version
  * version identification
  * writing

## Note types for grouped value (MODS legacy)
_Path: note.groupedValue_
  * caption
  * date
  * detail type
  * extent unit
  * list
  * marker
  * number
  * title
  * text

# Relatedresource types
_Path: relatedResource_
  * has original version: An initial form of the resource.
  * has other format: A version of the resource in a different physical or digital format.
  * has part: A constituent unit of the resource.
  * has version: A version of the resource with different intellectual content.
  * in series: The name of a series of publications to which the resource belongs.
  * other relation type: Resource type not otherwise described.
  * part of: A larger resource to which the resource belongs, such as a collection.
  * preceded by: A predecessor to the resource, such as a preceding journal title.
  * referenced by: Other resources that cite the resource, such as a catalog.
  * references: A resource which the resource references or cites.
  * related to: A generically related resource.
  * reviewed by: A review of the resource.
  * succeeded by: A successor to the resource, such as a subsequent journal title.

# Subject types
_Path: subject_
  * classification
  * conference
  * display
  * event
  * family
  * genre
  * map coordinates
  * name
  * occupation
  * organization
  * person
  * place
  * point coordinates
  * time
  * title
  * topic

## Subject note types
_Path: subject.note_
  * role

## Subject part types for structured value
_Path: subject.structuredValue_
  * activity dates
  * area
  * city
  * city section
  * conference
  * continent
  * country
  * county
  * end
  * east
  * event
  * extraterrestrial area
  * display
  * family
  * forename
  * genre
  * island
  * latitude
  * life dates
  * longitude
  * main title
  * name
  * north
  * occupation
  * ordinal
  * organization
  * part name
  * part number
  * person
  * place
  * region
  * south
  * start
  * state
  * surname
  * term of address
  * territory
  * time
  * title
  * topic
  * west

### Subject note types
_Path: subject.structuredValue.note_
  * affiliation
  * role: The relation of the subject entity to the resource.

## Subject types for grouped value (MODS legacy)
_Path: subject.groupedValue_
  * uniform: Form of title in Library of Congress title authority.

# Title types
_Path: title_
  * abbreviated: Abbreviated form of title for indexing or identification.
  * alternative: Variant title.
  * parallel: Title transcribed from the resource in multiple languages or scripts.
  * supplied: Title provided by metadata creator rather than transcribed from the resource.
  * translated: Title translated into another language.
  * transliterated: Title transliterated from non-Latin script to Latin script.
  * uniform: Form of title in Library of Congress title authority.

## Title note types
_Path: title.note_
  * associated name: A name linked to the title, such as for a name-title heading.
  * nonsorting character count: The number of characters at the beginning of the string to be disregarded when sorting.

## Title part types for structured value
_Path: title.structuredValue_
  * main title: The primary part of a multipart title.
  * nonsorting characters: A string at the beginning of the title to be disregarded when sorting.
  * part name: The distinct name of a resource as part of a series or multivolume set.
  * part number: The distinct number of a resource as part of a series or multivolume set.
  * subtitle: The secondary part of a title.
