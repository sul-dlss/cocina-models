
## <a name="resource-Agent">Agent</a>


An Agent - Person, Group, Organization, or other Acting body.

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **name** | *string* | Primary label or name for an Agent. | `"example"` |
| **sunetID** | *string* | Stanford University NetID for the Agent. | `"example"` |


## <a name="resource-Collection">Digital Repository Collection</a>


A group of Digital Repository Objects that indicate some type of conceptual grouping within the domain that is worth reusing across the system.

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **@context** | *string* | URI for the JSON-LD context definitions. | `"example"` |
| **@type** | *string* | The content type of the Collection. Selected from an established set of values.<br/> **one of:**`"http://cocina.sul.stanford.edu/models/collection.jsonld"` or `"http://cocina.sul.stanford.edu/models/curated-collection.jsonld"` or `"http://cocina.sul.stanford.edu/models/user-collection.jsonld"` or `"http://cocina.sul.stanford.edu/models/exhibit.jsonld"` or `"http://cocina.sul.stanford.edu/models/series.jsonld"` | `"http://cocina.sul.stanford.edu/models/collection.jsonld"` |
| **access:access** | *string* | Access level for the Collection.<br/> **one of:**`"world"` or `"stanford"` or `"location-based"` or `"citation-only"` or `"dark"` | `"world"` |
| **access:copyright** | *string* | The human readable copyright statement that applies to the Collection. | `"example"` |
| **access:download** | *string* | Download level for the Collection metadata.<br/> **one of:**`"world"` or `"stanford"` or `"location-based"` or `"citation-only"` or `"dark"` | `"world"` |
| **access:embargoReleaseDate** | *date-time* | Date when the Collection is released from an embargo, if an embargo exists. | `"2015-01-01T12:00:00Z"` |
| **access:license** | *string* | The license governing reuse of the Collection. Should be an IRI for known licenses (i.e. CC, RightsStatement.org URI, etc.). | `"example"` |
| **access:useAndReproductionStatement** | *string* | The human readable reuse and reproduction statement that applies to the Collection. | `"example"` |
| **access:termsOfUse** | *string* | License or terms of use governing reuse of the Collection. Should be a text statement. | `"example"` |
| **administrative:created** | *date-time* | When the resource in SDR was created. | `"2015-01-01T12:00:00Z"` |
| **administrative:deleted** | *boolean* | If the resource has been deleted (but not purged). | `true` |
| **administrative:gravestoneMessage** | *string* | Message describing why the object was deleted. | `"example"` |
| **administrative:isDescribedBy** | *string* | PURL/XML file that is a traditional representation of the metadata for the Collection. | `"example"` |
| **administrative:lastUpdated** | *date-time* | When the resource in SDR was last updated. | `"2015-01-01T12:00:00Z"` |
| **administrative:partOfProject** | *string* | Administrative or Internal project this resource is a part of. | `"example"` |
| **administrative:releaseTags** | *array* | Tags for release | `[{"to":"Searchworks","what":"self","date":"2015-01-01T12:00:00Z","who":"example","release":true}]` |
| **administrative:remediatedBy** | *array* | The Agent (User, Group, Application, Department, other) that remediated a Collection in SDR. | `[{"name":"example","sunetID":"example"}]` |
| **administrative:sdrPreserve** | *boolean* | If this resource should be sent to Preservation. | `true` |
| **citation** | *string* | Citation for the resource, including identifier, label, version, and a persistent URL to the object with SDR at the very least. | `"example"` |
| **dedupeIdentifier** | *string* | Identifier retrieved from identification.sourceId that stands for analog or source identifier that this resource is a digital representation of. | `"example"` |
| **depositor:name** | *string* | Primary label or name for an Agent. | `"example"` |
| **depositor:sunetID** | *string* | Stanford University NetID for the Agent. | `"example"` |
| **description:title** | *array* | The title of the item. | `[{"primary":true,"titleFull":"example"}]` |
| **externalIdentifier** | *string* | Identifier for the resource within the SDR architecture but outside of the repository. DRUID or UUID depending on resource type. Constant across resource versions. What clients will use calling the repository. Same as `identification.identifier` | `"example"` |
| **followingVersion** | *string* | Following version for the Collection within SDR. | `"example"` |
| **identification:DOI** | *string* | Digital Object Identifier (DOI) for the Collection within this repository. | `"example"` |
| **identification:catalogLinks/catalog** | *string* | Catalog that is the source of the linked record. | `"example"` |
| **identification:catalogLinks/catalogRecordId** | *string* | Record identifier that is unique within the context of the linked record's catalog. | `"example"` |
| **identification:catalogLinks/deliverMetadata** | *boolean* | If the linked record should be automatically updated when the Collection descriptive metadata changes. | `true` |
| **identification:catalogLinks/deriveMetadata** | *boolean* | If the Collection descriptive metadata should be automatically updated when the linked record changes. | `true` |
| **identification:catalogLinks/recordSchema** | *string* | Metadata schema of the linked record. | `"example"` |
| **identification:catalogLinks/recordScope** | *string* | Whether the linked record describes a resource that is broader than, equivalent to, or narrower than the resource the Collection represents.<br/> **one of:**`"broader"` or `"equivalent"` or `"narrower"` | `"broader"` |
| **identification:identifier** | *string* | Identifier for the Collection within the Stanford Digital Repository system | `"example"` |
| **identification:sameAs** | *string* | Another object, either external or internal to the system (if duplication occurs) that is the same digital resource as this Collection. | `"example"` |
| **identification:sdrUUID** | *string* | UUID previously minted for the resource within SDR2 / Fedora 3. | `"example"` |
| **identification:sourceId** | *string* | A source resource or object (perhaps but not necessarily analog or physical) that the Collection is a digital representation of. | `"example"` |
| **internalIdentifier** | *string* | Identifier for the resource within the repository. UUID, unique for each new version of a repository resource. | `"example"` |
| **label** | *string* | Primary processing label (can be same as title) for a Collection. | `"example"` |
| **precedingVersion** | *string* | Preceding version for the Collection within SDR. | `"example"` |
| **structural:hasAgreement** | *string* | Agreement that covers the deposit of the Collection into SDR. | `"example"` |
| **structural:hasMember** | *array* | Component digital repository objects or collections that are a part of this collection. | `[null]` |
| **structural:hasMemberOrders** | *array* | Provided sequences or orderings of members of the Collection, including some metadata about each sequence (i.e. sequence label, sequence type, if the sequence is primary, etc.). | `[{"@context":"example","@type":"http://cocina.sul.stanford.edu/models/sequence.jsonld","label":"example","startMember":"example","members":[null],"viewingDirection":"left-to-right"}]` |
| **structural:isTargetOf** | *string* | An Annotation instance that applies to the Collection. | `"example"` |
| **version** | *integer* | Version for the Collection within SDR. | `42` |


## <a name="resource-DRO">Digital Repository Object</a>


Domain-defined abstraction of a 'work'. Digital Repository Objects' abstraction is describable for our domain’s purposes, i.e. for management needs within our system.

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **@context** | *string* | URI for the JSON-LD context definitions. | `"example"` |
| **@type** | *string* | The content type of the DRO. Selected from an established set of values.<br/> **one of:**`"http://cocina.sul.stanford.edu/models/object.jsonld"` or `"http://cocina.sul.stanford.edu/models/3d.jsonld"` or `"http://cocina.sul.stanford.edu/models/agreement.jsonld"` or `"http://cocina.sul.stanford.edu/models/book.jsonld"` or `"http://cocina.sul.stanford.edu/models/document.jsonld"` or `"http://cocina.sul.stanford.edu/models/geo.jsonld"` or `"http://cocina.sul.stanford.edu/models/image.jsonld"` or `"http://cocina.sul.stanford.edu/models/page.jsonld"` or `"http://cocina.sul.stanford.edu/models/photograph.jsonld"` or `"http://cocina.sul.stanford.edu/models/manuscript.jsonld"` or `"http://cocina.sul.stanford.edu/models/map.jsonld"` or `"http://cocina.sul.stanford.edu/models/media.jsonld"` or `"http://cocina.sul.stanford.edu/models/track.jsonld"` or `"http://cocina.sul.stanford.edu/models/webarchive-binary.jsonld"` or `"http://cocina.sul.stanford.edu/models/webarchive-seed.jsonld"` | `"http://cocina.sul.stanford.edu/models/object.jsonld"` |
| **access:access** | *string* | Access level for the DRO.<br/> **one of:**`"world"` or `"stanford"` or `"location-based"` or `"citation-only"` or `"dark"` | `"world"` |
| **access:copyright** | *string* | The human readable copyright statement that applies to the DRO. | `"example"` |
| **access:download** | *string* | Download level for the DRO metadata.<br/> **one of:**`"world"` or `"stanford"` or `"location-based"` or `"citation-only"` or `"dark"` | `"world"` |
| **access:embargo:access** | *string* | Access level for the DRO when released from embargo.<br/> **one of:**`"world"` or `"stanford"` or `"location-based"` or `"citation-only"` or `"dark"` | `"world"` |
| **access:embargo:releaseDate** | *date-time* | Date when the DRO is released from an embargo. | `"2015-01-01T12:00:00Z"` |
| **access:license** | *string* | The license governing reuse of the DRO. Should be an IRI for known licenses (i.e. CC, RightsStatement.org URI, etc.). | `"example"` |
| **access:useAndReproductionStatement** | *string* | The human readable reuse and reproduction statement that applies to the DRO. | `"example"` |
| **access:termsOfUse** | *string* | License or terms of use governing reuse of the DRO. Should be a text statement. | `"example"` |
| **access:visibility** | *integer* | Percentage of the DRO that is visibility during an embargo period | `42` |
| **administrative:created** | *date-time* | When the resource in SDR was created. | `"2015-01-01T12:00:00Z"` |
| **administrative:deleted** | *boolean* | If the resource has been deleted (but not purged). | `true` |
| **administrative:gravestoneMessage** | *string* | Message describing why the object was deleted. | `"example"` |
| **administrative:isDescribedBy** | *string* | Pointer to the PURL/XML file that is a traditional representation of the metadata for the DRO. | `"example"` |
| **administrative:lastUpdated** | *date-time* | When the resource in SDR was last updated. | `"2015-01-01T12:00:00Z"` |
| **administrative:partOfProject** | *string* | Administrative or Internal project this resource is a part of. | `"example"` |
| **administrative:releaseTags** | *array* | Tags for release | `[{"to":"Searchworks","what":"self","date":"2015-01-01T12:00:00Z","who":"example","release":true}]` |
| **administrative:remediatedBy** | *array* | The Agent (User, Group, Application, Department, other) that remediated a DRO in SDR. | `[{"name":"example","sunetID":"example"}]` |
| **administrative:sdrPreserve** | *boolean* | If this resource should be sent to Preservation. | `true` |
| **citation** | *string* | Citation for the resource, including identifier, label, version, and a persistent URL to the object with SDR at the very least. | `"example"` |
| **dedupeIdentifier** | *string* | Identifier retrieved from identification.sourceId that stands for analog or source identifier that this resource is a digital representation of. | `"example"` |
| **depositor:name** | *string* | Primary label or name for an Agent. | `"example"` |
| **depositor:sunetID** | *string* | Stanford University NetID for the Agent. | `"example"` |
| **description:title** | *array* | The title of the item. | `[{"primary":true,"titleFull":"example"}]` |
| **externalIdentifier** | *string* | Identifier for the resource within the SDR architecture but outside of the repository. DRUID or UUID depending on resource type. Constant across resource versions. What clients will use calling the repository. Same as `identification.identifier` | `"example"` |
| **followingVersion** | *string* | Following version for the Object within SDR. | `"example"` |
| **geographic:iso19139** | *string* | Geographic ISO 19139 XML metadata | `"example"` |
| **identification:catalogLinks/catalog** | *string* | Catalog that is the source of the linked record. | `"example"` |
| **identification:catalogLinks/catalogRecordId** | *string* | Record identifier that is unique within the context of the linked record's catalog. | `"example"` |
| **identification:catalogLinks/deliverMetadata** | *boolean* | If the linked record should be automatically updated when the DRO descriptive metadata changes. | `true` |
| **identification:catalogLinks/deriveMetadata** | *boolean* | If the DRO descriptive metadata should be automatically updated when the linked record changes. | `true` |
| **identification:catalogLinks/recordSchema** | *string* | Metadata schema of the linked record. | `"example"` |
| **identification:catalogLinks/recordScope** | *string* | Whether the linked record describes a resource that is broader than, equivalent to, or narrower than the resource the DRO represents.<br/> **one of:**`"broader"` or `"equivalent"` or `"narrower"` | `"broader"` |
| **identification:doi** | *string* | Digital Object Identifier (DOI) for the DRO within this repository. | `"example"` |
| **identification:identifier** | *string* | Identifier for the Digital Repository Object within the Stanford Digital Repository system | `"example"` |
| **identification:sameAs** | *string* | Another object, either external or internal to the system (if duplication occurs) that is the same digital resource as this DRO. | `"example"` |
| **identification:sdrUUID** | *string* | UUID previously minted for the resource within SDR2 / Fedora 3. | `"example"` |
| **identification:sourceId** | *string* | A source resource or object (perhaps but not necessarily analog or physical) that the DRO is a digital representation of. | `"example"` |
| **internalIdentifier** | *string* | Identifier for the resource within the repository. UUID, unique for each new version of a repository resource. | `"example"` |
| **label** | *string* | Primary processing label (can be same as title) for a DRO. | `"example"` |
| **permissions:approvalRequired** | *boolean* | Indicates if approval is required to deposit or manage the resource in SDR. | `true` |
| **permissions:approvers** | *array* | Agents who are required to approve deposit or management of this resource in SDR. | `[{"name":"example","sunetID":"example"}]` |
| **precedingVersion** | *string* | Preceding version for the Object within SDR. | `"example"` |
| **structural:contains** | *array* | Filesets that contain the digital representations (Files) of the DRO. | `[{"@context":"example","@type":"http://cocina.sul.stanford.edu/models/fileset.jsonld","depositor":{"name":"example","sunetID":"example"},"label":"example","externalIdentifier":"example","internalIdentifier":"example","version":42,"precedingVersion":"example","followingVersion":"example","access":{"access":"world","download":"world"},"administrative":{"created":"2015-01-01T12:00:00Z","deleted":true,"gravestoneMessage":"example","lastUpdated":"2015-01-01T12:00:00Z","partOfProject":"example","sdrPreserve":true,"remediatedBy":[{"name":"example","sunetID":"example"}]},"identification":{"identifier":"example","sdrUUID":"example"},"structural":{"contains":[{"@context":"example","@type":"http://cocina.sul.stanford.edu/models/file.jsonld","depositor":{"name":"example","sunetID":"example"},"externalIdentifier":"example","filename":"example","format":"example","hasMessageDigests":[{"type":"md5","digest":"example"}],"hasMimeType":"example","label":"example","presentation":{"height":42,"width":42},"size":42,"internalIdentifier":"example","use":"example","version":42,"precedingVersion":"example","followingVersion":"example","access":{"access":"world","download":"world"},"administrative":{"created":"2015-01-01T12:00:00Z","deleted":true,"gravestoneMessage":"example","lastUpdated":"2015-01-01T12:00:00Z","partOfProject":"example","sdrPreserve":true,"shelve":true,"remediatedBy":[{"name":"example","sunetID":"example"}]},"identification":{"filename":"example","identifier":"example","sdrUUID":"example"},"structural":{"isContainedBy":"example","isTargetOf":"example"}}],"isContainedBy":"example","isTargetOf":"example"}}]` |
| **structural:hasAgreement** | *string* | Agreement that covers the deposit of the DRO into SDR. | `"example"` |
| **structural:hasMember** | *array* | Component or 'children' digital repository objects that are a part or portion of this 'parent' or aggregate DRO. | `[null]` |
| **structural:hasMemberOrders** | *array* | Provided sequences or orderings of members of the Object, including some metadata about each sequence (i.e. sequence label, sequence type, if the sequence is primary, etc.). | `[{"@context":"example","@type":"http://cocina.sul.stanford.edu/models/sequence.jsonld","label":"example","startMember":"example","members":[null],"viewingDirection":"left-to-right"}]` |
| **structural:isMemberOf** | *string* | Collection that this DRO is a member of | `"example"` |
| **structural:isTargetOf** | *string* | An Annotation instance that applies to the DRO. | `"example"` |
| **version** | *integer* | Version for the DRO within SDR. | `42` |


## <a name="resource-Description">Description</a>


The description of a work

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **title** | *array* | The title of the item. | `[{"primary":true,"titleFull":"example"}]` |


## <a name="resource-File">File</a>


Binaries that are the basis of what our domain manages. Binaries here do not include metadata files generated for the domain's own management purposes.

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **@context** | *string* | URI for the JSON-LD context definitions. | `"example"` |
| **@type** | *string* | The content type of the File.<br/> **one of:**`"http://cocina.sul.stanford.edu/models/file.jsonld"` | `"http://cocina.sul.stanford.edu/models/file.jsonld"` |
| **access:access** | *string* | Access level for the File. If "dark" this won't go into public xml contentMetadata.<br/> **one of:**`"world"` or `"stanford"` or `"location-based"` or `"citation-only"` or `"dark"` | `"world"` |
| **access:download** | *string* | Download level for the File binary.<br/> **one of:**`"world"` or `"stanford"` or `"location-based"` or `"citation-only"` or `"dark"` | `"world"` |
| **administrative:created** | *date-time* | When the resource in SDR was created. | `"2015-01-01T12:00:00Z"` |
| **administrative:deleted** | *boolean* | If the resource has been deleted (but not purged). | `true` |
| **administrative:gravestoneMessage** | *string* | Message describing why the resource was deleted. | `"example"` |
| **administrative:lastUpdated** | *date-time* | When the resource in SDR was last updated. | `"2015-01-01T12:00:00Z"` |
| **administrative:partOfProject** | *string* | Administrative or Internal project this resource is a part of. | `"example"` |
| **administrative:remediatedBy** | *array* | The Agent (User, Group, Application, Department, other) that remediated this File in SDR. | `[{"name":"example","sunetID":"example"}]` |
| **administrative:sdrPreserve** | *boolean* | If this resource should be sent to Preservation. | `true` |
| **administrative:shelve** | *boolean* | If this resource should be sent to Stacks. | `true` |
| **depositor:name** | *string* | Primary label or name for an Agent. | `"example"` |
| **depositor:sunetID** | *string* | Stanford University NetID for the Agent. | `"example"` |
| **externalIdentifier** | *string* | Identifier for the resource within the SDR architecture but outside of the repository. UUID. Constant across resource versions. What clients will use calling the repository. Same as `identification.identifier` | `"example"` |
| **filename** | *string* | Filename for a file. Can be same as label. | `"example"` |
| **followingVersion** | *string* | Following version for the File within SDR. | `"example"` |
| **format** | *string* | Format of the File. | `"example"` |
| **hasMessageDigests/digest** | *string* | The digest value | `"example"` |
| **hasMessageDigests/type** | *string* | The algorithm that was used<br/> **one of:**`"md5"` or `"sha1"` | `"md5"` |
| **hasMimeType** | *string* | MIME Type of the File. | `"example"` |
| **identification:filename** | *string* | Filename for the File from originating systems. | `"example"` |
| **identification:identifier** | *string* | Identifier for the File within the Stanford Digital Repository system | `"example"` |
| **identification:sdrUUID** | *string* | UUID previously minted for the resource within SDR2 / Fedora 3. | `"example"` |
| **internalIdentifier** | *string* | Identifier for the resource within the repository. UUID, unique for each new version of a repository resource. | `"example"` |
| **label** | *string* | Primary processing label (can be same as title) for a File. | `"example"` |
| **precedingVersion** | *string* | Preceding version for the File within SDR. | `"example"` |
| **presentation:height** | *integer* | Height in pixels | `42` |
| **presentation:width** | *integer* | Width in pixels | `42` |
| **size** | *integer* | Size of the File (binary) in bytes. | `42` |
| **structural:isContainedBy** | *string* | Fileset that contains this File. | `"example"` |
| **structural:isTargetOf** | *string* | An Annotation instance that applies to this File. | `"example"` |
| **use** | *string* | Use for the File. | `"example"` |
| **version** | *integer* | Version for the File within SDR. | `42` |


## <a name="resource-Fileset">Fileset</a>


Relevant groupings of Files. Also called a File Grouping.

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **@context** | *string* | URI for the JSON-LD context definitions. | `"example"` |
| **@type** | *string* | The content type of the Fileset.<br/> **one of:**`"http://cocina.sul.stanford.edu/models/fileset.jsonld"` | `"http://cocina.sul.stanford.edu/models/fileset.jsonld"` |
| **access:access** | *string* | Access level for the Fileset.<br/> **one of:**`"world"` or `"stanford"` or `"location-based"` or `"citation-only"` or `"dark"` | `"world"` |
| **access:download** | *string* | Download level for the Fileset metadata.<br/> **one of:**`"world"` or `"stanford"` or `"location-based"` or `"citation-only"` or `"dark"` | `"world"` |
| **administrative:created** | *date-time* | When the resource in SDR was created. | `"2015-01-01T12:00:00Z"` |
| **administrative:deleted** | *boolean* | If the resource has been deleted (but not purged). | `true` |
| **administrative:gravestoneMessage** | *string* | Message describing why the resource was deleted. | `"example"` |
| **administrative:lastUpdated** | *date-time* | When the resource in SDR was last updated. | `"2015-01-01T12:00:00Z"` |
| **administrative:partOfProject** | *string* | Administrative or Internal project this resource is a part of. | `"example"` |
| **administrative:remediatedBy** | *array* | The Agent (User, Group, Application, Department, other) that remediated a Fileset in SDR. | `[{"name":"example","sunetID":"example"}]` |
| **administrative:sdrPreserve** | *boolean* | If this resource should be sent to Preservation. | `true` |
| **depositor:name** | *string* | Primary label or name for an Agent. | `"example"` |
| **depositor:sunetID** | *string* | Stanford University NetID for the Agent. | `"example"` |
| **externalIdentifier** | *string* | Identifier for the resource within the SDR architecture but outside of the repository. UUID. Constant across resource versions. What clients will use calling the repository. Same as `identification.identifier` | `"example"` |
| **followingVersion** | *string* | Following version for the Fileset within SDR. | `"example"` |
| **identification:identifier** | *string* | Identifier for the Fileset within the Stanford Digital Repository system | `"example"` |
| **identification:sdrUUID** | *string* | UUID previously minted for the resource within SDR2 / Fedora 3. | `"example"` |
| **internalIdentifier** | *string* | Identifier for the resource within the repository. UUID, unique for each new version of a repository resource. | `"example"` |
| **label** | *string* | Primary processing label (can be same as title) for a Fileset. | `"example"` |
| **precedingVersion** | *string* | Preceding version for the Fileset within SDR. | `"example"` |
| **structural:contains** | *array* | Files that are members of the fileset. | `[{"@context":"example","@type":"http://cocina.sul.stanford.edu/models/file.jsonld","depositor":{"name":"example","sunetID":"example"},"externalIdentifier":"example","filename":"example","format":"example","hasMessageDigests":[{"type":"md5","digest":"example"}],"hasMimeType":"example","label":"example","presentation":{"height":42,"width":42},"size":42,"internalIdentifier":"example","use":"example","version":42,"precedingVersion":"example","followingVersion":"example","access":{"access":"world","download":"world"},"administrative":{"created":"2015-01-01T12:00:00Z","deleted":true,"gravestoneMessage":"example","lastUpdated":"2015-01-01T12:00:00Z","partOfProject":"example","sdrPreserve":true,"shelve":true,"remediatedBy":[{"name":"example","sunetID":"example"}]},"identification":{"filename":"example","identifier":"example","sdrUUID":"example"},"structural":{"isContainedBy":"example","isTargetOf":"example"}}]` |
| **structural:isContainedBy** | *string* | Parent DRO that is represented by the files in this Fileset. | `"example"` |
| **structural:isTargetOf** | *string* | An Annotation instance that applies to this Fileset. | `"example"` |
| **version** | *integer* | Version for the Fileset within SDR. | `42` |


## <a name="resource-ReleaseTag">Release Tag</a>


A tag that indicates the item or collection should be released.

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **date** | *date-time* | When did this action happen | `"2015-01-01T12:00:00Z"` |
| **release** | *boolean* | Should it be released or withdrawn. Release is coded as true and withdraw as false | `true` |
| **to** | *string* | What platform is it released to<br/> **one of:**`"Searchworks"` or `"Earthworks"` | `"Searchworks"` |
| **what** | *string* | What is being released. This item or the whole collection.<br/> **one of:**`"self"` or `"collection"` | `"self"` |
| **who** | *string* | Who did this release | `"example"` |


## <a name="resource-Sequence">Resource Sequence</a>


A sequence or ordering of resources within a Collection or Object.

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **@context** | *string* | URI for the JSON-LD context definitions. | `"example"` |
| **@type** | *string* | The type of Sequence.<br/> **one of:**`"http://cocina.sul.stanford.edu/models/sequence.jsonld"` or `"http://cocina.sul.stanford.edu/models/primary-sequence.jsonld"` | `"http://cocina.sul.stanford.edu/models/sequence.jsonld"` |
| **label** | *string* | Label for the sequence or ordering. | `"example"` |
| **members** | *array* | Identifiers for Members in their stated Order for the Sequence. | `[null]` |
| **startMember** | *string* | Identifier for the first member of the sequence. | `"example"` |
| **viewingDirection** | *string* | The direction that a sequence of canvases should be displayed to the user<br/> **one of:**`"left-to-right"` or `"right-to-left"` or `"top-to-bottom"` or `"bottom-to-top"` | `"left-to-right"` |


## <a name="resource-Title">Title</a>


A title of a work

### Attributes

| Name | Type | Description | Example |
| ------- | ------- | ------- | ------- |
| **primary** | *boolean* | Is this the primary title for the object | `true` |
| **titleFull** | *string* | The full title for the object | `"example"` |


