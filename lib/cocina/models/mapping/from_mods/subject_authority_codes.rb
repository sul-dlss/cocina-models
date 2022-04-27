# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
module Cocina
  module Models
    module Mapping
      module FromMods
        # Helper class - provides subject authority codes
        class SubjectAuthorityCodes
          # Subject codes: https://id.loc.gov/vocabulary/subjectSchemes.html
          # curl https://id.loc.gov/vocabulary/subjectSchemes.madsrdf.json | jq '[.[0]."http://www.loc.gov/mads/rdf/v1#hasMADSSchemeMember"[]."@id"[44:]]'
          SUBJECT_CODES = %w[
            quiding
            trt
            dissao
            kaunokki
            mpirdes
            erfemn
            mech
            gtt
            msc
            sbiao
            tero
            noraf
            shsples
            trtsa
            aiatsisp
            cstud
            ica
            lcsh
            local
            mero
            dbn
            ilpt
            nalnaf
            tips
            kassu
            bella
            aktp
            dcs
            noubomn
            unescot
            muzeukc
            czenas
            cht
            biccbmc
            csalsct
            blnpn
            fnhl
            galestne
            odlt
            dtict
            blmlsh
            lemb
            dltlt
            idszbzna
            lcac
            msh
            muzeukn
            ntissc
            shbe
            kaa
            she
            nznb
            apaist
            socio
            fast
            ipat
            qrma
            rugeo
            stw
            pmcsg
            bib1814
            rma
            kubikat
            rswk
            jlabsh
            unescot
            inspect
            kupu
            aass
            drama
            lnmmbr
            isis
            ogst
            eurovocsl
            vmj
            nicem
            bhammf
            henn
            abne
            nlgaf
            afo
            tekord
            cilla
            pleiades
            czmesh
            sgce
            watrest
            ated
            csht
            gnis
            netc
            gcipplatform
            wot
            ibsen
            tucua
            ukslc
            ashlnl
            swemesh
            emnmus
            lua
            ept
            no-ubo-mr
            reo
            nbiemnfag
            pkk
            scgdst
            homoit
            sthus
            hamsun
            juho
            kulo
            kupu
            samisk
            ulan
            sears
            poliscit
            atg
            itglit
            aucsh
            cct
            bicssc
            icpsr
            tbjvp
            norbok
            nimacsc
            asft
            kta
            mtirdes
            rpe
            taxhs
            taika
            collett
            tlsh
            tha
            hlasstg
            sbt
            hoidokki
            bisacrt
            unescot
            asth
            solstad
            csh
            noubojur
            bt
            francis
            asrcrfcd
            lapponica
            rerovoc
            unbisn
            barn
            hapi
            iest
            kssbar
            musa
            rurkp
            spines
            renib
            aucsh
            iescs
            tisa
            idszbzes
            popinte
            pmbok
            usaidt
            finmesh
            gccst
            csahssa
            kdm
            jupo
            gem
            sk
            eet
            agrifors
            cash
            kkts
            liito
            cctf
            eum
            rero
            skon
            tsr
            eurovocfr
            mipfesd
            koko
            lcdgt
            muso
            fire
            cabt
            georeft
            sgc
            dcs
            fmesh
            smda
            ndlsh
            ttka
            afset
            ttll
            mmm
            scisshl
            ddcri
            ericd
            idszbz
            umitrist
            ddcut
            ceeus
            czenas
            embne
            hrvmesh
            kauno
            samisk
            itrt
            aat
            kao
            maaq
            rswkaf
            slem
            bhb
            bokbas
            aiatsisl
            gst
            idszbzzg
            maotao
            nsbncf
            francis
            ntcpsc
            ltcsh
            reo
            test
            tho
            huc
            waqaf
            hkcan
            asrctoa
            ept
            ddcrit
            nasat
            lacnaf
            conorsi
            idas
            nbdbt
            swd
            asrcseo
            opms
            muzvukci
            cct
            udc
            peri
            idszbzzh
            chirosh
            liv
            rpe
            sipri
            geonet
            bjornson
            tgn
            bidex
            allars
            eclas
            eflch
            idszbzzk
            dit
            lcstt
            mar
            masa
            pascal
            jlabsh
            kito
            lctgm
            ccte
            bisacmt
            pepp
            eurovocen
            gnd
            agrovocf
            pmont
            pmt
            psychit
            qlsp
            ram
            scbi
            ntids
            ebfem
            lemac
            sgc
            snt
            ccsa
            bet
            unbist
            dcs
            puho
            ktpt
            sao
            swemesh
            dbn
            fes
            vcaadu
            ndlsh
            tsht
            ntcsd
            jhpk
            wgst
            tlka
            jurivoc
            nlgkk
            inist
            rvmgd
            bhashe
            yso
            naf
            nzggn
            sfit
            thub
            atla
            tesa
            dltt
            gcipmedia
            larpcal
            lcshac
            ncjt
            kitu
            ssg
            nal
            ktta
            thesoz
            wpicsh
            ordnok
            est
            bisacsh
            csapa
            kto
            ciesiniv
            precis
            sanb
            vffyl
            eks
            aiatsiss
            kula
            rvm
            tasmas
            pha
            humord
            qtglit
            idsbb
            rasuqam
            scot
            cdcng
            sigle
            sosa
            nskps
            stw
            aedoml
            jhpb
            noram
            agrovocs
            ysa
            fssh
            agrovoc
            qrmak
            blcpss
            mesh
            albt
            khib
            nlgsh
            pascal
            prvt
            qrma
            nlmnaf
            ipsp
            helecon
            bibalex
            valo
          ].freeze

          # Classification codes: https://id.loc.gov/vocabulary/classSchemes.html
          # curl https://id.loc.gov/vocabulary/classSchemes.madsrdf.json | jq '[.[0]."http://www.loc.gov/mads/rdf/v1#hasMADSSchemeMember"[]."@id"[42:]]'
          CLASSIFICATION_CODES = [
            'cadocs',
            'bliss',
            'nlm',
            'msdocs',
            'ddc9',
            'rubbkm',
            'no-ujur-cnip',
            'ddc14',
            'codocs',
            'ddc17',
            'mpilcs',
            'rubbk',
            'rugasnti',
            'skb',
            'sswd',
            'stub',
            'cstud',
            'undocs',
            'zdbs',
            'fldocs',
            'cutterec',
            'iadocs',
            'ddc11',
            'cslj',
            'loovs',
            'veera',
            'ardocs',
            'acmccs',
            'ddc6',
            'vsiso',
            'ohdocs',
            'rich',
            'ddc22',
            'ladocs',
            'blsrissc',
            'ddc3',
            'sudocs',
            'mpkkl',
            'ykl',
            'swank',
            'rilm',
            'celex',
            'rpb',
            'dopaed',
            'cacodoc',
            'fiaf',
            'kktb',
            'kuvacs',
            'nydocs',
            'txdocs',
            'utklklass',
            'no-ujur-cmr',
            'ddc7',
            'rubbknp',
            'inspec',
            'ridocs',
            'udc',
            'nicem',
            'kfmod',
            'frtav',
            'ddc4',
            'no-ureal-cb',
            'rswk',
            'usgslcs',
            'ddc23',
            'teatkl',
            'nwbib',
            'bar',
            'accs',
            'farl',
            'rubbks',
            'widocs',
            'ddc1',
            'lcc',
            'rubbkk',
            'suaslc',
            'ddc20',
            'midocs',
            'azdocs',
            'ncdocs',
            'cddir',
            'msc',
            'niv',
            'agrissc',
            'fcps',
            'nvdocs',
            'z',
            'okdocs',
            'utk',
            'agricola',
            'ddc2',
            'ddc21',
            'ifzs',
            'sbb',
            'upsylon',
            'utdocs',
            'ipc',
            'uef',
            'chfbn',
            'tykoma',
            'jelc',
            'anscr',
            'rubbkmv',
            'clutscny',
            'ddc',
            'rubbkd',
            'nasasscg',
            'nhcp',
            'bcmc',
            'ddc18',
            'bcl',
            'oosk',
            'gfdc',
            'kssb',
            'no-ureal-cg',
            'laclaw',
            'siso',
            'rubbkn',
            'rueskl',
            'gadocs',
            'ddc12',
            'bkl',
            'ccpgq',
            'finagri',
            'no-ureal-ca',
            'ordocs',
            'ddc15',
            'rvk',
            'egedeklass',
            'ncsclt',
            'methepp',
            'sfb',
            'noterlyd',
            'pssppbkj',
            'ssd',
            'bisacsh',
            'taykl',
            'kab',
            'misklass',
            'flarch',
            'mmlcc',
            'nmdocs',
            'wydocs',
            'pim',
            'farma',
            'nbdocs',
            'ddc16',
            'blissc',
            'sddocs',
            'modocs',
            'rubbko',
            'scdocs',
            'asb',
            'smm',
            'ssgn',
            'utklklassex',
            'naics',
            'knt',
            'ekl',
            'siblcs',
            'ddc13',
            'clc',
            'taikclas',
            'ddc8',
            'njb',
            'sdnb',
            'ksdocs',
            'ghbs',
            'fid',
            'padocs',
            'mu',
            'wadocs',
            'moys',
            'ddc19',
            'mf-klass',
            'ivdcc',
            'ddc5',
            'ics',
            'ddc10',
            'ubtkl/2'
          ].freeze

          # Genre codes: https://id.loc.gov/vocabulary/genreFormSchemes.html
          # curl https://id.loc.gov/vocabulary/genreFormSchemes.madsrdf.json | jq '[.[0]."http://www.loc.gov/mads/rdf/v1#hasMADSSchemeMember"[]."@id"[46:]]'
          GENRE_CODES = %w[
            bgtchm
            rbpub
            ftamc
            tgfbne
            rbpap
            saogf
            rvmgf
            rbgenr
            rdacontent
            gnd-content
            estc
            rbprov
            sgp
            radfg
            alett
            nimafc
            lobt
            rbmscv
            barngf
            gnd-music
            nmc
            cjh
            fgtpcm
            fbg
            gnd-carrier
            reveal
            nbdbgf
            marcgt
            gsafd
            nzcoh
            gmd
            isbdcontent
            gmgpc
            amg
            marcform
            ngl
            rbbin
            gtlm
            marccategory
            marcsmd
            dct
            proysen
            rbpri
            gatbeg
            rdamedia
            mim
            rbtyp
            muzeukv
            isbdmedia
            gnd
            lcgft
            rdacarrier
            migfg
          ].freeze

          # Name-title codes: https://id.loc.gov/vocabulary/nameTitleSchemes.html
          # curl https://id.loc.gov/vocabulary/nameTitleSchemes.madsrdf.json | jq '[.[0]."http://www.loc.gov/mads/rdf/v1#hasMADSSchemeMember"[]."@id"[46:]]'
          NAME_TITLE_CODES = %w[
            hkcan
            nliaf
            bnfaf
            conorsi
            gnd
            sanb
            hapi
            gkd
            unbisn
            ckhw
            lacnaf
            nznb
            banqa
            iconauth
            cantic
            nta
            naf
            cerit
            bibalex
            ccucaut
            abne
            bibbi
            nalnaf
            ulan
            sucnsaf
            fautor
            nlmnaf
            finaf
          ].freeze

          # Cartographic codes: http://www.loc.gov/standards/sourcelist/cartographic-data.html
          CARTOGRAPHIC_CODES = %w[
            aadcg
            acgms
            ahcb
            bcgnis
            bnlq
            bound
            cbf
            cga
            cgndb
            cgotw
            csa
            cwg
            darome
            dkcaw
            edm
            erpn
            esriarc
            fnib
            gbos
            geoapn
            geobase
            geogndb
            geonames
            geonet
            gettytgn
            ghpn
            glogaz
            gnis
            gnrnsw
            gnt
            goj
            gooearth
            gpn
            gufn
            inmun
            knab
            lwip
            mapland
            margaz
            mwgd
            natmap
            nlaci
            nsgn
            ntpnr
            nws
            nzggn
            nzpnd
            other
            peakbag
            pnosa
            pleiades
            pwme
            qpns
            rsd
            sagns
            taw
            usdp
            volwrld
            vow
            wdpa
            wfbcia
            whl
            wikiped
            wld
            wpntpl
          ].freeze

          # Occupation codes: http://www.loc.gov/standards/sourcelist/occupation.html
          OCCUPATION_CODES = %w[
            dot
            iaat
            ilot
            itoamc
            lcdgt
            onet
            ooh
            oscroc
            raam
            rvmgd
            tbit
            toit
            trot
          ].freeze

          # Country codes: http://www.loc.gov/standards/sourcelist/country.html
          COUNTRY_CODES = %w[
            marccountry
            iso3166
            iso3166-1
            iso3166-2
          ].freeze

          # Geographic codes: http://www.loc.gov/standards/sourcelist/geographic-area.html
          GEOGRAPHIC_CODES = %w[
            cagraq
            ccga
            marcgac
          ].freeze

          ISO_CODES = %w[
            ISO19115TopicCategory
            iso639-2b
            iso639-3
          ].freeze

          MARC_CODES = %w[
            marcfrequency
            marcorg
            marcrelator
            marctarget
          ].freeze

          PARKER = %w[
            Corpus Christi College
            James Catalog
          ].freeze

          OTHER_CODES = %w[
            wikidata
            EPSG
          ].freeze

          SUBJECT_AUTHORITY_CODES = SUBJECT_CODES + CLASSIFICATION_CODES + GENRE_CODES + NAME_TITLE_CODES \
            + CARTOGRAPHIC_CODES + OCCUPATION_CODES + COUNTRY_CODES + GEOGRAPHIC_CODES \
            + ISO_CODES + MARC_CODES + PARKER + OTHER_CODES
        end
      end
    end
  end
end
# rubocop:enable Metrics/ClassLength
