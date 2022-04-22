# frozen_string_literal: true

module Cocina
  module FromFedora
    class Descriptive
      # Maps identifier types
      class IdentifierType
        COCINA_TO_STANDARD_IDENTIFIER_SCHEMES = {
          'AGROVOC ID' => 'agrovoc',
          'AllMovie ID' => 'allmovie',
          'AllMusic ID' => 'allmusic',
          'AlloCiné ID' => 'allocine',
          'American National Biography Online ID' => 'amnbo',
          'ANSI' => 'ansi',
          'Apis ID' => 'apis',
          'Artsy ID' => 'artsy',
          'BFI ID' => 'bfi',
          'Biblioteca Nacional de España ID' => 'datoses',
          'Biographical Directory of the United States Congress ID' => 'bdusc',
          'BnF catalogue général ID' => 'bnfcg',
          'CANTIC ID' => 'cantic',
          'CGNDB ID' => 'cgndb',
          'Danacode ID' => 'danacode',
          'Det Danske Filminstitut Filmdatabasen ID' => 'dkfilm',
          'Discogs ID' => 'discogs',
          'DOI' => 'doi',
          'EAN' => 'ean',
          'EIDR ID' => 'eidr',
          'FAST' => 'fast',
          'Filmportal ID' => 'filmport',
          'Find a Grave ID' => 'findagr',
          'Freebase ID' => 'freebase',
          'Geographic Names Database ID' => 'geogndb',
          'GeoNames ID' => 'geonames',
          'GND ID' => 'gnd',
          'GNIS ID' => 'gnis',
          'Gran enciclopèdia catalana ID' => 'gec',
          'GTIN-14 ID' => 'gtin-14',
          'Handle' => 'hdl',
          'IBDB ID' => 'ibdb',
          'IdRef' => 'idref',
          'IMDb ID' => 'imdb',
          'ISAN' => 'isan',
          'ISBN' => 'isbn',
          'ISBN registrant element ID' => 'isbnre',
          'ISIL' => 'isil',
          'ISMN' => 'ismn',
          'ISNI' => 'isni',
          'ISO' => 'iso',
          'ISRC' => 'isrc',
          'ISSN' => 'issn',
          'ISSN-L' => 'issn-l',
          'ISTC' => 'istc',
          'ISWC' => 'iswc',
          'ITAR' => 'itar',
          'KinoPoisk ID' => 'kinipo',
          'LC Manuscript Division ID' => 'lcmd',
          'LCCN' => 'lccn',
          'Libraries Australia ID' => 'libaus',
          'local' => 'local',
          'matrix number' => 'matrix-number',
          'MOMA ID' => 'moma',
          'Munzinger ID' => 'munzing',
          'music plate' => 'music-plate',
          'music publisher' => 'music-publisher',
          'MusicBrainz ID' => 'musicb',
          'Número de Identificación de las Publicaciones Oficiales ID' => 'nipo',
          'National Gallery of Art ID' => 'nga',
          'National Portrait Gallery ID' => 'npg',
          'NNDB ID' => 'nndb',
          'ODNB ID' => 'odnb',
          'OpenStreetMap ID' => 'opensm',
          'ORCID' => 'orcid',
          'Oxford DNB Index ID' => 'oxforddnb',
          'PORT.hu ID' => 'porthu',
          'RBMS Binding Term' => 'rbmsbt',
          'RBMS Genre Terms ID' => 'rbmsgt',
          'RBMS Paper Term' => 'rbmspt',
          'RBMS Printing and Publishing Term' => 'rbmsppe',
          'RBMS Provenance Evidence' => 'rbmspe',
          'RBMS Relationship Designator' => 'rbmsrd',
          'RBMS Type Evidence' => 'rbmste',
          'ResearcherID' => 'rid',
          'RKDartists ID' => 'rkda',
          'Scholar Universe ID' => 'scholaru',
          'Scope ID' => 'scope',
          'Scopus Author ID' => 'scopus',
          'SICI' => 'sici',
          'Smithsonian American Art Museum ID' => 'saam',
          'sound recording issue number' => 'issue-number',
          'Sports Reference: Baseball ID' => 'sprfbsb',
          'Sports Reference: Basketball ID' => 'sprfbsk',
          'Sports Reference: College Basketball ID' => 'sprfcbb',
          'Sports Reference: College Football ID' => 'sprfcfb',
          'Sports Reference: Hockey ID' => 'sprfhoc',
          'Sports Reference: Olympic Sports ID' => 'sprfoly',
          'Sports Reference: Pro Football ID' => 'sprfpfb',
          'Spotify ID' => 'spotify',
          'Standard Technical Report Number' => 'strn',
          'stock number' => 'stock-number',
          'Svensk Filmdatabas ID' => 'svfilm',
          'Swets (Netherlands) ID' => 'swets',
          'Tate Artist ID' => 'tatearid',
          'TGN' => 'gettytgn',
          'Theatricalia ID' => 'theatr',
          'Trove ID' => 'trove',
          'U.S. National Gazetteer Feature Name ID' => 'natgazfid',
          'ULAN' => 'gettyulan',
          'UPC' => 'upc',
          'URI' => 'uri',
          'URN' => 'urn',
          'VIAF' => 'viaf',
          'video recording number' => 'videorecording-identifier',
          'Web NDL Authority' => 'wndla',
          'Wikidata' => 'wikidata'
        }.freeze

        COCINA_TO_STANDARD_IDENTIFIER_SOURCE_CODES = {
          'AAT' => 'gettyaat',
          'actionable ISBN' => 'isbn-a',
          'AGORHA ID' => 'agorha',
          'Agricultural Thesaurus and Glossary' => 'atg',
          'archINFORM location ID' => 'archinl',
          'archINFORM person ID' => 'archinpe',
          'archINFORM project ID' => 'archinpr',
          'Archnet authority' => 'archna',
          'Archnet site ID' => 'archns',
          'ARK' => 'ark',
          'ARK ID' => 'arkid',
          'Art UK Artists ID' => 'artukart',
          'Art UK Artworks ID' => 'artukaw',
          'BALaT People & Institutions ID' => 'balat',
          'BBC Things ID' => 'bbcth',
          'Belvedere Artist ID' => 'belvku',
          'Belvedere Work ID' => 'belvwrk',
          'Benezit Dictionary of Artists ID' => 'benezit',
          'BIBBI authority' => 'bibbi',
          'Biographies of the Entomologists of the World ID' => 'bew',
          'Biography portal of the Netherlands ID' => 'bpn',
          'British Standards Institution ID' => 'bsi',
          'CABI Thesaurus ID' => 'cabt',
          'Canadiana Authority' => 'cana',
          'CERL Thesaurus term' => 'cerl',
          'Cesko-Slovenská filmová databáze ID' => 'csfdcz',
          'Clara: Database of Women Artists ID' => 'clara',
          'Collective Biographies of Women Persons ID' => 'cbwpid',
          'Currículo Lattes ID' => 'lattes',
          'Dictionnaire des peintres belges ID' => 'dpb',
          'Digital atlas of the Roman Empire ID' => 'darome',
          'Early Modern Letters Online ID' => 'emlo',
          'European Case Law Identifier ID' => 'ecli',
          'Fide Chess Profile ID' => 'fidecp',
          'Film Affinity ID' => 'filmaff',
          'FIS Athlete ID' => 'fisa',
          'Gemeenschappelijke Thesaurus Audiovisuele Archieven ID' => 'gtaa',
          'Global Agricultural Concept Scheme ID' => 'gacsch',
          'Goodreads Author ID' => 'goodra',
          'Great Britain National Archives ID' => 'nagb',
          'Great Russian Encyclopedia ID' => 'bigenc',
          'IAAF Athletes ID' => 'iaafa',
          'Iconography Authority' => 'iconauth',
          'Identificativo SBN (Servizio bibliotecario nazionale)' => 'isbnsbn',
          'ISFDB author directory ID' => 'isfdbau',
          'ISFDB award directory ID' => 'isfdbaw',
          'ISFDB magazine directory ID' => 'isfdbma',
          'ISFDB publisher directory ID' => 'isfdbpu',
          'J. Paul Getty Museum Artist ID' => 'gettyart',
          'J. Paul Getty Museum Object ID' => 'gettyobj',
          'Kunstindeks Danmark Artist ID' => 'kda',
          'Kunstindeks Danmark Work ID' => 'kdw',
          'Legal entity identifier' => 'lei',
          'Marine Gazetteer ID' => 'margaz',
          'MESH' => 'mesh',
          'MovieMeter Film ID' => 'moviemetf',
          'MovieMeter Regisseur ID' => 'moviemetr',
          "Musée d'Orsay Catalogue des oeuvres fiche oeuvre" => 'mocofo',
          "Musée d'Orsay Répertoire des artistes notice artiste" => 'morana',
          'Music Sales Classical ID' => 'muscl',
          'National Gallery of Victoria Artist ID' => 'ngva',
          'National Gallery of Victoria Work ID' => 'ngvw',
          'OFDb ID' => 'ofdb',
          'ONIX ID' => 'onix',
          'Pacific Coast Architecture Database building ID' => 'pcadbu',
          'Pacific Coast Architecture Database firm ID' => 'pcadpf',
          'Pacific Coast Architecture Database person ID' => 'pcadpe',
          'PermID' => 'permid',
          'Personen uit de Nederlandse Thesaurus van Auteursnamen ID' => 'pnta',
          'PIC ID' => 'picnypl',
          'Pleiades ID' => 'pleiades',
          'Prabook ID' => 'prabook',
          'Quan Guo Bao Kan Suo Yin ID' => 'cnbksy',
          'ROR' => 'ror',
          'Russian National Heritage Registry for Books ID' => 'knpam',
          'S2A3 Biographical Database of Southern African Science ID' => 's2a3bd',
          'Science Museum Group People ID' => 'smgp',
          'Semantic Scholar author ID' => 'ssaut',
          'SNAC' => 'snac',
          'STW thesaurus ID' => 'stw',
          'U.S. National Archives Catalog ID' => 'nacat',
          'UNESCO thesaurus ID' => 'unescot',
          'Verzeichnis der Drucke des 16. Jahrhunderts ID' => 'vd16',
          'Verzeichnis der Drucke des 17. Jahrhunderts ID' => 'vd17',
          'Verzeichnis der Drucke des 18. Jahrhunderts ID' => 'vd18',
          'VGMdb artist ID' => 'vgmdb',
          'X Games Athlete ID' => 'xgamea',
          'ZooBank author ID' => 'zbaut'
        }.freeze

        OTHER_COCINA_TYPES = [
          'arXiv',
          'audio issue number',
          'audio take',
          'award number',
          'barcode',
          'BIBCODE',
          'CODEN',
          'copyright number',
          'CrossRef Funder ID',
          'EAN13',
          'EISSN',
          'ETD ID',
          'fingerprint',
          'GRID',
          'IGSN',
          'LC Overseas Acquisition ID',
          'LISID',
          'LISSN',
          'music distributor number',
          'music opus number',
          'music serial number',
          'music thematic number',
          'NBN',
          'OCLC',
          'other system control number',
          'PMID',
          'postal registration',
          'publisher number',
          'PURL',
          'report number',
          'SIRSI',
          'STM',
          'study number',
          'Symphony authority file identifier',
          'Symphony catkey',
          'URL',
          'W3 ID'
        ].freeze

        ALL_COCINA_TYPES = OTHER_COCINA_TYPES + COCINA_TO_STANDARD_IDENTIFIER_SOURCE_CODES.keys + COCINA_TO_STANDARD_IDENTIFIER_SCHEMES.keys

        STANDARD_IDENTIFIER_SOURCE_CODES = 'standard identifier source codes'
        STANDARD_IDENTIFIER_SCHEMES = 'standard identifier schemes'
        COCINA = 'cocina'

        # @param [String] mods_type
        # @return [String, String, String] cocina type or nil, matched mods type (with correct case) or nil, identifier source or nil
        def self.cocina_type_for_mods_type(mods_type)
          return [nil, nil, nil] if mods_type.blank?

          # Try to find a standard identifier scheme type (case insensitive)
          COCINA_TO_STANDARD_IDENTIFIER_SCHEMES.each_pair do |cocina_type, check_mods_type|
            if check_mods_type&.downcase == mods_type.downcase
              return [cocina_type, check_mods_type,
                      STANDARD_IDENTIFIER_SCHEMES]
            end
          end

          # Try to find a standard identifier scheme type (case insensitive)
          COCINA_TO_STANDARD_IDENTIFIER_SOURCE_CODES.each_pair do |cocina_type, check_mods_type|
            if check_mods_type&.downcase == mods_type.downcase
              return [cocina_type, check_mods_type,
                      STANDARD_IDENTIFIER_SOURCE_CODES]
            end
          end

          # Try to find a Cocina type (case insensitive)
          ALL_COCINA_TYPES.each do |cocina_type|
            return [cocina_type, nil, COCINA] if cocina_type.casecmp(mods_type).zero?
          end

          [mods_type, nil, nil]
        end

        def self.mods_type_for_cocina_type(cocina_type)
          COCINA_TO_STANDARD_IDENTIFIER_SCHEMES[cocina_type] || COCINA_TO_STANDARD_IDENTIFIER_SOURCE_CODES[cocina_type] || cocina_type
        end
      end
    end
  end
end
