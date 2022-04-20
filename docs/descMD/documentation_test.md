# Access accessContact types
_Path: access.accessContact.type_
  * email
     * Email address for a contact person or institution concerning the resource.
  * repository
     * Institution providing access to the resource.
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
    * Last or family name.
  * transliteration
    * Name originally in non-Latin script presented phonetically using Latin characters.
### Contributor name part types for structuredValue
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
    * Last or family name.
  * term of address
    * Title or other signifier associated with name.
### Contributor name types for groupedValue (MODS legacy)
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
# Note types
_Path: note.type_
  * abstract
  * access
  * access note
    * Information about how to access the resource.
    * Deprecated. Preferred usage: access.
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
    * Deprecated. Preferred usage: biographical/historical.
  * biography
  * boat note
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
## Title part types for structuredValue
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
