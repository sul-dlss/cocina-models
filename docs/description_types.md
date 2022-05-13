## Access accessContact types
_Path: access.accessContact.type_
  * email
    * Email address for a contact person or institution concerning the resource.
  * repository
    * Institution providing access to the resource.
## Access digitalLocation types
_Path: access.digitalLocation.type_
  * discovery
    * Online location for the purpose of discovering the resource.
## Access note types
_Path: access.note.type_
  * access restriction
    * Restrictions on or conditions for gaining access to the resource.
  * display label
    * Display label for the purl.
  * license
    * License describing allowed uses of the resource.
  * use and reproduction
    * Information related to allowed uses of the resource in other contexts.
## Access physicalLocation types
_Path: access.physicalLocation.type_
  * discovery
    * Location where a user may find the resource.
  * location
    * Physical location of the resource, or path to the resource on a hard drive or disk.
  * repository
    * The institution holding the resource.
  * series
    * Archival series of the resource.
    * Deprecated. Preferred usage: relatedResource.title.value with relatedResource type "host" and displayLabel "Series"
  * shelf locator
    * Identifier or shelfmark indicating the location of the resource.
## AdminMetadata note types
_Path: adminMetadata.note.type_
  * record information
    * General information about the metadata record.
  * record origin
    * The source of the record, such as another record transformed to generate the current record.
# Contributor types
_Path: contributor.type_
  * conference
    * An event focusing on a particular topic or discipline.
  * event
    * A time-bound occurrence.
  * family
    * A group of individuals related by blood or personal alliance.
  * organization
    * An institution or other corporate or collective body.
  * person
    * An individual identity.
  * unspecified others
    * Designator for one or more additional contributors not named individually.
## Contributor identifier types
_Path: contributor.identifier.type_
  * ORCID
    * Identifier from orcid.org.
  * Wikidata
    * Identifier from wikidata.org.
## Contributor name types
_Path: contributor.name.type_
  * alternative
    * Additional nonpreferred form of name.
  * display
    * Preferred form of the name for display.
  * forename
    * First or given name or names.
  * inverted full name
    * Name given in last name, first name order.
  * pseudonym
    * Name used that differs from legal or primary form of name.
  * surname
    * Last or family name or names.
  * transliteration
    * Name originally in non-Latin script presented phonetically using Latin characters.
### Contributor name part types for structured value
_Path: contributor.name.structuredValue.type_
  * activity dates
    * The date or dates when someone was producing work.
  * forename
    * First or given name or names.
  * life dates
    * Birth and death dates, or dates when an entity was in existence.
  * name
    * Name provided alongside additional information.
  * ordinal
    * Indicator that the name is one in a series (e.g. Elizabeth I, Martin Luther King, Jr.).
  * surname
    * Last or family name or names.
  * term of address
    * Title or other signifier associated with name.
### Contributor name types for grouped value (MODS legacy)
_Path: contributor.name.groupedValue.type_
  * alternative
    * Additional nonpreferred form of name.
  * name
    * Primary form of name within group of values.
  * pseudonym
    * Name used that differs from legal or primary form of name.
## Contributor note types
_Path: contributor.note.type_
  * affiliation
    * Institution with which the contributor is associated.
  * citation status
    * Indicator of whether the contributor should be included in the citation.
  * description
    * Biographical information about the contributor.
# Event types
_Path: event.type_
  * acquisition
    * The transferral of ownership of a resource to a repository.
  * capture
    * A record of the resource in a fixed form at a specific time.
  * collection
    * The addition of a resource to a set of other resources.
  * copyright
    * The activity by which a resource may be considered subject to copyright law.
  * copyright notice
    * An explicit statement that a resource is under copyright.
  * creation
    * The coming into being of a resource.
  * deaccession
    * The removal of a resource from a repository.
  * degree conferral
    * The institutional approval of a thesis or other resource leading to an academic degree.
  * deposit
    * The submission of a resource to a repository.
  * development
    * The creation of a print from a photographic negative or other source medium.
  * distribution
    * The delivery of the resource to an external audience.
  * generation
    * The creation of a resource by an automatic or natural process.
  * manufacture
    * The physical assembly of a resource, often in multiple copies, for publication or other distribution.
  * modification
    * A change to an existing resource.
  * performance
    * The enactment of an artistic or cultural work for an audience, such as a play.
  * presentation
    * The discussion of an academic or intellectual work for an audience, such as a seminar.
  * production
    * The physical assembly of a resource not considered published, such as page proofs for a book.
  * provenance
    * The resource's origins and history.
  * publication
    * The publishing or issuing of a resource.
  * recording
    * The initial fixation to a medium of live audio and/or visual activity.
  * release
    * Making a resource available to a broader audience.
  * submission
    * The provision of a resource for review or evaluation.
  * validity
    * When a resource takes effect, such as a revised train schedule.
  * withdrawal
    * The removal of previous access to a resource, often due to its obsolescence.
## Event date types
_Path: event.date.type_
  * accompanying letter
    * Used in Athanasius Kircher project.
    * Deprecated.
  * acquisition
    * The transferral of ownership of a resource to a repository.
  * capture
    * A record of the resource in a fixed form at a specific time.
  * collection
    * The addition of a resource to a set of other resources.
  * composition
    * Used in Athanasius Kircher project.
    * Deprecated.
  * copy
    * Used in Athanasius Kircher project.
    * Deprecated.
  * copyright
    * The activity by which a resource may be considered subject to copyright law.
  * coverage
  * creation
    * The coming into being of a resource.
  * deaccession
    * The removal of a resource from a repository.
  * degree conferral
    * The institutional approval of a thesis or other resource leading to an academic degree.
  * deposit
    * The submission of a resource to a repository.
  * developed
    * The creation of a print from a photographic negative or other source medium.
    * Deprecated. Preferred usage: development
  * development
    * The creation of a print from a photographic negative or other source medium.
  * distribution
    * The delivery of the resource to an external audience.
  * generation
    * The creation of a resource by an automatic or natural process.
  * Gregorian
    * Deprecated. Preferred usage: event.date.note.value with type "calendar"
  * Hebrew
    * Deprecated. Preferred usage: event.date.note.value with type "calendar"
  * Hijri calendar
    * Deprecated. Preferred usage: event.date.note.value with type "calendar"
  * Islamic
    * Deprecated. Preferred usage: event.date.note.value with type "calendar"
  * Julian
    * Deprecated. Preferred usage: event.date.note.value with type "calendar"
  * letter
    * Used in Athanasius Kircher project.
    * Deprecated.
  * letter referred to
    * Used in Athanasius Kircher project.
    * Deprecated.
  * manufacture
    * The physical assembly of a resource, often in multiple copies, for publication or other distribution.
  * manuscript
    * Used in Athanasius Kircher project.
    * Deprecated.
  * manuscript referred to
    * Used in Athanasius Kircher project.
    * Deprecated.
  * modification
    * A change to an existing resource.
  * new document
    * Used in Athanasius Kircher project.
    * Deprecated.
  * new style letter
    * Used in Athanasius Kircher project.
    * Deprecated.
  * observation
    * Used in Athanasius Kircher project.
    * Deprecated.
  * old style letter
    * Used in Athanasius Kircher project.
    * Deprecated.
  * original sent
    * Used in Athanasius Kircher project.
    * Deprecated.
  * performance
    * The enactment of an artistic or cultural work for an audience, such as a play.
  * presentation
    * The discussion of an academic or intellectual work for an audience, such as a seminar.
  * proclamation
    * Used in Athanasius Kircher project.
    * Deprecated.
  * production
    * The physical assembly of a resource not considered published, such as page proofs for a book.
  * publication
    * The publishing or issuing of a resource.
  * quoted
    * Used in Athanasius Kircher project.
    * Deprecated.
  * recording
    * The initial fixation to a medium of live audio and/or visual activity.
  * release
    * Making a resource available to a broader audience.
  * Revolutionary calendar
    * Deprecated. Preferred usage: event.date.note.value with type "calendar"
  * submission
    * The provision of a resource for review or evaluation.
  * validity
    * When a resource takes effect, such as a revised train schedule.
  * withdrawal
    * The removal of previous access to a resource, often due to its obsolescence.
### Event date note types
_Path: event.date.note.type_
  * calendar
    * The calendar system used for a date.
### Event date part types for structured value
_Path: event.date.structuredValue.type_
  * start
    * The start date in a range.
  * end
    * The end date in a range.
## Event note types
_Path: event.note.type_
  * copyright statement
    * A formal declaration of copyright on a resource.
  * edition
    * A published version of a resource issued at one time.
  * frequency
    * How often a resource is issued, such as monthly.
  * issuance
    * How the resource is issued, such as serially.
# Form types
_Path: form.type_
  * carrier
    * Format of the resource's storage medium.
  * data format
    * The structure of a dataset.
  * digital origin
    * The relationship of a digitized resource to a previous format.
  * extent
    * The size or dimensions of the resource.
  * form
    * A description of the materiality of the resource.
  * genre
    * The intellectual category of a resource based on style, form, content, etc.
  * map projection
    * The method used to represent the curvature of a planet on a flat plane.
  * map scale
    * The size ratio of the map image to the depicted area.
  * material
    * The physical components constituting the resource.
  * media
    * The technology required to mediate interactions with a resource.
  * media type
  * reformatting quality
    * The use for which the reproduction quality of the resource was intended (e.g. access, preservation).
  * resource type
    * The general format category of the resource.
  * technique
    * The method used to create the resource.
  * type
## Form part types for structured value
_Path: form.structuredValue.type_
  * type
    * Used for H2 deposits.
  * subtype
    * Used for H2 deposits.
## Geographic form types
_Path: geographic.form.type_
  * data format
  * media type
  * type
## Geographic subject types
_Path: geographic.subject.type_
  * bounding box coordinates
    * A series of coordinates forming the boundaries of the depicted area.
  * coverage
    * The name of the area the resource depicts.
  * point coordinates
    * A pair of coordinates showing the latitude and longitude of the depicted area.
### Geographic subject part types for structured value
_Path: geographic.subject.structuredValue.type_
  * east
    * A directional indicator for a point of a bounding box.
  * latitude
    * The angular distance of a place north or south from the equator.
  * longitude
    * The angular distance of a place east or west from the standard meridian.
  * north
    * A directional indicator for a point of a bounding box.
  * south
    * A directional indicator for a point of a bounding box.
  * west
    * A directional indicator for a point of a bounding box.
# Identifier types
_Path: identifier.type_
  * accession
    * Deprecated. Preferred usage: accession number
  * accession number
  * alternate case number
  * anchor
  * Apis ID
  * ARK
  * arXiv
  * case identifier
  * case number
  * CCP
  * CLC
  * CSt
  * CStRLIN
  * CTC
  * Data Provider Digital Object Identifier
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
  * SICI
  * SIRSI
  * Source ID
  * sourceID
    * Deprecated. Preferred usage: Source ID
  * stock number
  * SUL catalog key
  * Swets (Netherlands) ID
  * UPC
  * URI
  * URN
  * videorecording identifier
  * West Mat #
  * Wikidata
# Note types
_Path: note.type_
  * abstract
    * A short overview of a research article or other work.
  * access
    * Information about gaining access to a resource.
  * access note
    * Deprecated. Preferred usage: access
  * acquisition
    * The transfer of a resource to a repository.
  * action
  * additional physical form
    * Other formats of the resource.
  * additions
    * Resources added after initial acquisition.
  * admin
    * Administrative or internal use.
  * affiliation
    * Institution with which a person or other entity is associated.
  * arrangement
    * The organization of an archival or other collection.
  * bibliographic
  * bibliography
    * Other resources with additional information about the resource.
  * binding
  * biographical/historical
    * Background on a person, organization, or other entity strongly associated with the resource.
  * biographical/historical note
    * Deprecated. Preferred usage: biographical/historical
  * biography
    * Background on a person strongly associated with the resource.
  * boat note
  * citation/reference
    * Other resources that cite this resource.
  * codicology
  * collation
  * colophon
  * condition
    * Physical wear on an object.
  * contact
    * Contact information for someone responsible for the resource.
  * content
    * The information the resource contains.
  * content note
    * Deprecated. Preferred usage: content
  * content warning
    * Cautionary information about offensive or triggering resource content.
  * contents
    * Deprecated. Preferred usage: content
  * copyright
    * A creator's legal ownership of a resource's content.
  * creation/production credits
    * Cast and crew associated with the production of a resource.
  * date
    * Information about a date or dates associated with the resource.
  * date/sequential designation
  * decoNote
    * Deprecated. Preferred usage: decoration
  * decoration
  * description
    * Information describing the resource.
  * digitization
    * The process of creating a digital representation of a physical object.
  * dimensions
    * The size of an object in terms of area or volume.
  * duration
    * The length of a time-based resource.
  * email
    * An email address related to the resource.
  * event
    * A time-bound occurrence associated with a resource.
  * exhibitions
    * Public displays of the resource as part of an exhibit.
  * explicit
  * foliation
  * funding
    * Financial support for producing, acquiring, or otherwise processing the resource.
  * general
  * genre type
  * geography
  * hand note
  * handNote
    * Deprecated. Preferred usage: hand note
  * handwritten
  * host
  * incipit
  * instrumentation
    * Musical instruments involved in the performance of a resource.
  * language
  * layout
  * local
    * A note with local application.
  * location
  * material
  * medium of performance
  * names
  * numbering
  * original location
  * other
  * other relation type
  * ownership
  * part
  * performer
  * performers
  * preferred citation
    * The preferred form for citing a resource.
  * provenance
    * The resource's origins and history.
  * publications
    * Other published works related to the resource.
  * qualifications
  * quote
  * reassembly
    * The return of an object to a whole after being separated into parts.
  * reference
  * references
  * reformatting
  * related publication
  * reproduction
  * research
  * restriction
  * rubric
  * scope and content
  * secfol
    * Deprecated. Preferred usage: second folio
  * second folio
  * secondFolio
    * Deprecated. Preferred usage: second folio
  * source characteristics
  * source identifier
  * statement of responsibility
    * The contributors to a work as transcribed from a title page.
  * summary
  * system details
  * system requirements
  * table of contents
  * target audience
  * technical note
  * thesis
  * transcript
  * translation
  * unit
  * update
  * use and reproduction
  * venue
    * The location of a public performance or other event.
  * version
  * version identification
  * writing
## Note types for grouped value (MODS legacy)
_Path: note.groupedValue.type_
  * caption
  * date
  * detail type
  * extent unit
  * list
  * marker
  * number
  * title
  * text
# RelatedResource types
_Path: relatedResource.type_
  * has original version
    * An initial form of the resource.
  * has other format
    * A version of the resource in a different physical or digital format.
  * has part
    * A constituent unit of the resource.
  * has version
    * A version of the resource with different intellectual content.
  * in series
    * The name of a series of publications to which the resource belongs.
  * other relation type
    * Resource type not otherwise described.
  * part of
    * A larger resource to which the resource belongs, such as a collection.
  * preceded by
    * A predecessor to the resource, such as a preceding journal title.
  * referenced by
    * Other resources that cite the resource, such as a catalog.
  * references
    * A resource which the resource references or cites.
  * related to
    * A generically related resource.
  * reviewed by
    * A review of the resource.
  * succeeded by
    * A successor to the resource, such as a subsequent journal title.
# Subject types
_Path: subject.type_
  * classification
    * A coded reference to the main subjects of the resource according to a larger system.
  * conference
    * An event focusing on a particular topic or discipline.
  * display
    * Preferred form of the value for display.
  * event
    * A time-bound occurrence.
  * family
    * A group of individuals related by blood or personal alliance.
  * genre
    * The intellectual category of a resource based on style, form, content, etc.
  * map coordinates
    * Bounding box or point coordinates describing the area represented by a map or other geographic resource.
  * name
    * The name of an entity whose type is not known.
  * occupation
    * A profession or job category associated with the content of a resource.
  * organization
    * An institution or other corporate or collective body.
  * person
    * An individual identity.
  * place
    * A geographic location associated with the content of a resource.
  * point coordinates
    * The latitude and longitude of a place associated with the content of a resource.
  * time
    * The temporal period associated with the content of a resource.
  * title
    * A work that is the subject of the resource.
  * topic
    * Terms representing the information contained in or other relevant attributes of a resource.
## Subject note types
_Path: subject.note.type_
  * affiliation
    * Institution with which the contributor is associated.
  * description
    * Biographical information about the contributor.
  * role
    * The relation of the subject entity to the resource.
## Subject part types for structured value
_Path: subject.structuredValue.type_
  * activity dates
    * The date or dates when someone was producing work.
  * area
    * A non-jurisdictional geographic entity.
  * city
    * An inhabited place incorporated as a city or equivalent.
  * city section
    * A smaller unit within a populated place, such as a neighborhood.
  * conference
    * An event focusing on a particular topic or discipline.
  * continent
    * Large land mass or portion of land mass considered to be a continent.
  * country
    * A political entity considered to be a country.
  * county
    * A political division of a state or the largest local administrative unit.
  * display
    * Preferred form of the value for display.
  * east
    * A directional indicator for a point of a bounding box.
  * end
    * The end date in a range.
  * event
    * A time-bound occurrence.
  * extraterrestrial area
    * An entity, space, or feature not on Earth.
  * family
    * A group of individuals related by blood or personal alliance.
  * forename
    * First or given name or names.
  * genre
    * The intellectual category of a resource based on style, form, content, etc.
  * island
    * A tract of land surrounded by water but not itself a separate continent or country.
  * latitude
    * The angular distance of a place north or south from the equator.
  * life dates
    * Birth and death dates, or dates when an entity was in existence.
  * longitude
    * The angular distance of a place east or west from the standard meridian.
  * main title
    * Title provided alongside additional information.
  * name
    * Name provided alongside additional information.
  * nonsorting characters
    * A string at the beginning of the title to be disregarded when sorting.
  * north
    * A directional indicator for a point of a bounding box.
  * occupation
    * A profession or job category associated with the content of a resource.
  * ordinal
    * Indicator that the name is one in a series (e.g. Elizabeth I, Martin Luther King, Jr.).
  * organization
    * An institution or other corporate or collective body.
  * part name
    * The distinct name of a resource as part of a series or multivolume set.
  * part number
    * The distinct number of a resource as part of a series or multivolume set.
  * person
    * An individual identity.
  * place
    * A geographic location associated with the content of a resource.
  * region
    * An area that incorporates more than one first-order jurisdiction.
  * south
    * A directional indicator for a point of a bounding box.
  * start
    * The start date in a range.
  * state
    * A first-order political jurisdiction under country, including provinces, cantons, etc.
  * subtitle
    * The secondary part of a title.
  * surname
    * Last or family name or names.
  * term of address
    * Title or other signifier associated with name.
  * territory
    * A geographical area belonging to or under the jurisdiction of a governmental authority.
  * time
    * The temporal period associated with the content of a resource.
  * title
    * A work that is the subject of the resource.
  * topic
    * Terms representing the information contained in or other relevant attributes of a resource.
  * west
    * A directional indicator for a point of a bounding box.
### Subject note types
_Path: subject.structuredValue.note.type_
  * affiliation
    * Institution with which the contributor is associated.
  * description
    * Biographical information about the contributor.
  * role
    * The relation of the subject entity to the resource.
## Subject types for grouped value (MODS legacy)
_Path: subject.groupedValue.type_
  * uniform
    * Form of title in Library of Congress title authority file.
# Title types
_Path: title.type_
  * abbreviated
    * Abbreviated form of title for indexing or identification.
  * alternative
    * Variant title.
  * parallel
    * Title transcribed from the resource in multiple languages or scripts.
  * supplied
    * Title provided by metadata creator rather than transcribed from the resource.
  * translated
    * Title translated into another language.
  * transliterated
    * Title transliterated from non-Latin script to Latin script.
  * uniform
    * Form of title in Library of Congress title authority.
## Title note types
_Path: title.note.type_
  * associated name
    * A name linked to the title, such as for a name-title heading.
  * nonsorting character count
    * The number of characters at the beginning of the string to be disregarded when sorting.
## Title part types for structured value
_Path: title.structuredValue.type_
  * main title
    * The primary part of a multipart title.
  * nonsorting characters
    * A string at the beginning of the title to be disregarded when sorting.
  * part name
    * The distinct name of a resource as part of a series or multivolume set.
  * part number
    * The distinct number of a resource as part of a series or multivolume set.
  * subtitle
    * The secondary part of a title.
