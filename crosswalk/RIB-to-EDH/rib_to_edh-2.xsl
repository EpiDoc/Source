<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:html="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="html xs t skos rdf xi" version="2.0">

    <!-- 
   created from  IRT - generate table for EDH
     RV 07-07-2009 ; GB 2009-12-08
     
    
     RIB xml to EDH  in one xsl transformation
     
     updates: 2014-03-10 Pietro Liuzzo
     updates: 2014-03-18 Scott Vanderbilt, Pietro Liuzzo
     updates: 2014-04-02 Pietro Liuzzo
     updates 2014-04-04 Gabriel Bodard and Pietro Liuzzo
    updates 2014-04-09 James Cowey, Frank Grieshaber, Pietro Liuzzo 
    updates 2014-04-25 Scott Vanderbilt, James Cowey, Pietro Liuzzo
    updates 2014-05-08 Pietro Liuzzo (some changes for validation of results to xml2edh prepared by Frank Grieshaber)
    updates 2014-06-04 Gabriel Bodard and Pietro Liuzzo
    updates 2014-07-02 Francisca Feraudi Gruénais and Pietro Liuzzo
    
   
     to be run on:  RIB files list, produces one file with all records.
    
     
-->


    <xsl:import href="../../EPIDOC-XSLT/start-txt.xsl"/>
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:strip-space elements="w name"/>

    <xsl:template match="/">
        <EDH>
            <xsl:for-each select="//td[position()=3]">
                <xsl:if test="not(contains(preceding-sibling::td[2],'HD'))">
                    <xsl:variable name="currentinscription">
                        <!--  path to be modified according to XML files directory -->
                        <xsl:sequence
                            select="document(concat('../../../../../../../../../../Users/pietro/ribrepo/rib/trunk/project/inscriptions/rib',format-number(.,'00000'),'.xml'))"
                        />
                    </xsl:variable>
                    <record>
                        <xsl:attribute name="ref">
                            <xsl:value-of
                                select=" concat('http://romaninscriptionsofbritain.org/rib/inscriptions/', $currentinscription//t:idno[@type='rib'])"
                            />
                        </xsl:attribute>
                        <xsl:if test="number(preceding-sibling::td[1])">
                            <tmUri>
                                <xsl:value-of
                                    select="concat('http://www.trismegistos.org/text/',preceding-sibling::td[1])"
                                />
                            </tmUri>
                        </xsl:if>
                        <provinz>
                            <xsl:value-of
                                select="$currentinscription//t:geogName[@type='ancientRegion']"/>
                        </provinz>
                        <land>
                            <xsl:value-of
                                select="$currentinscription//t:geogName[@type='modernCountry']"/>
                        </land>
                        <fo_antik>
                            <xsl:if
                                test="$currentinscription//t:provenance[@type='found']/t:placeName[@subtype='pleiades']/@ref[not(contains(.,'XXXXX'))]">
                                <xsl:attribute name="pleiades">
                                    <xsl:value-of
                                        select="$currentinscription//t:provenance[@type='found']/t:placeName[@subtype='pleiades']/@ref"
                                    />
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of
                                select="$currentinscription//t:provenance[@type='found']/t:placeName[@subtype='pleiades'][not(contains(.,'XXXXX'))]"
                            />
                        </fo_antik>
                        <fo_modern>
                            <xsl:if
                                test="$currentinscription//t:provenance[@type='found']/t:placeName[@subtype='geonames']/@ref[not(contains(.,'XXXXX'))]">
                                <xsl:attribute name="geonames">
                                    <xsl:value-of
                                        select="$currentinscription//t:provenance[@type='found']/t:placeName[@subtype='geonames']/@ref"
                                    />
                                </xsl:attribute>
                            </xsl:if>
                            <xsl:value-of select="$currentinscription//t:origin/t:placeName[1]"/>
                        </fo_modern>
                        <xsl:if test="$currentinscription//t:date[@type='foundDate'][@when]">

                            <!-- Some RIB documents have more than one provenance, and thus more than one date, which made the original code fail 
                                now it selects the maximum value among those available
                                -->

                            <xsl:for-each
                                select="$currentinscription//t:date[@type='foundDate']/@when">
                                <xsl:sort select="." data-type="number" order="descending"/>
                                <xsl:if test="position() = 1">
                                    <fundjahr>
                                        <xsl:value-of select="."/>
                                    </fundjahr>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                        <fundstelle>
                            <xsl:value-of
                                select="$currentinscription//t:provenance[@type='found']/t:placeName[@subtype='geonames']"
                            />
                        </fundstelle>
                        <aufbewahrung>
                            <xsl:choose>
                                <!-- Some RIB documents have more than one msIdentifier/settlement, which made the original code fail -->
                                <xsl:when
                                    test="$currentinscription//t:provenance[@type='lastLocation']//t:orgName[1]">
                                    <xsl:variable name="institutionlist">
                                        <xsl:value-of
                                            select="$currentinscription//t:provenance[@type='lastLocation']//t:orgName[1]/@key"
                                        />
                                    </xsl:variable>
                                    <xsl:if
                                        test="document('../../../../../../../../../../Users/pietro/ribrepo/rib/trunk/project/institution-groups/inst-index-name.xml')//t:name[@key = $institutionlist]">
                                        <xsl:value-of
                                            select="document('../../../../../../../../../../Users/pietro/ribrepo/rib/trunk/project/institution-groups/inst-index-name.xml')//t:name[@key = $institutionlist]/ancestor::t:ref/following-sibling::t:settlement"
                                        />
                                    </xsl:if>
                                    <xsl:text>: </xsl:text>
                                    <xsl:value-of
                                        select="$currentinscription//t:provenance[@type='lastLocation']//t:orgName[1]"
                                    />
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </aufbewahrung>
                        <dekor>
                            <xsl:if test="contains($currentinscription, 'decoration')">
                                <xsl:text>J</xsl:text>
                            </xsl:if>
                        </dekor>
                        <i_gattung>
                            <xsl:variable name="igattung">
                                <xsl:if test="$currentinscription//t:msItem[@class]">
                                    <xsl:sequence
                                        select="substring-after($currentinscription//t:msItem/@class, '#')"
                                    />
                                </xsl:if>
                            </xsl:variable>
                            <!-- values not comparable:   text_unknown, graffito, tbd, magic.other, fragment-->
                            <xsl:choose>
                                <xsl:when test="$igattung='dedicatory'">
                                    <xsl:text>Building/dedicatory inscription</xsl:text>
                                </xsl:when>
                                <xsl:when test="$igattung='building'">
                                    <xsl:text>Building/dedicatory inscription</xsl:text>
                                </xsl:when>
                                <xsl:when test="$igattung='building.century'">
                                    <xsl:text>Building/dedicatory inscription</xsl:text>
                                </xsl:when>
                                <xsl:when test="$igattung='Building/dedicatory inscription'">
                                    <xsl:text>Building/dedicatory inscription</xsl:text>
                                </xsl:when>
                                <xsl:when test="$igattung='funerary.epitaph'">
                                    <xsl:text>Epitaph</xsl:text>
                                </xsl:when>
                                <xsl:when test="$igattung='place_marker.milestone'">
                                    <xsl:text>Mile-/Leaguestone</xsl:text>
                                </xsl:when>
                                <xsl:when test="$igattung='place_marker.boundary'">
                                    <xsl:text>Boundary inscription</xsl:text>
                                </xsl:when>
                                <xsl:when test="$igattung='magic.defixio'">
                                    <xsl:text>Defixio</xsl:text>
                                </xsl:when>
                                <!--                              values not used this time
                                        - Acclamation
                                    - Adnuntiatio
                                    - Assignation inscription
                                    - Calendar
                                    - Elogium
                                    - Honorific inscription
                                    - Identification inscription
                                    - Label
                                    - List
                                    - Military diploma
                                    - Owner/artist inscription
                                    - Prayer
                                    - Private legal inscription
                                    - Public legal inscription
                                    - Seat inscription
                                    - Votive inscription-->
                            </xsl:choose>
                        </i_gattung>
                        <denkmaltyp>
                            <!-- values not comparable:   object_unknown, fragment, intrumentum.letter, rock.quarry -->
                            <!--                                values which might rather belong to type of inscription (need to change encoding in source files: letter)-->
                            <xsl:variable name="denkmaltyp">
                                <xsl:if test="$currentinscription//t:objectType[1]">
                                    <xsl:sequence
                                        select="substring-after($currentinscription//t:objectType[1]/@ana, '#')"
                                    />
                                </xsl:if>
                            </xsl:variable>
                            <xsl:choose>

                                <xsl:when test="$denkmaltyp='altar'">
                                    <xsl:text>Altar</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='column'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='column.commemorative'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='column.votive'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='column.shaft'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.casing'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.frieze'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.jamb'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.pediment'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.plinth'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.cornice'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.pilaster'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.arch-head'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.frame'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.finial'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.strip'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.voussoir-stone'">
                                    <xsl:text>Architectural member</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.unknown'">
                                    <xsl:text>Architectural member?</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='base'">
                                    <xsl:text>Base</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='base.tombstone'">
                                    <xsl:text>Base</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='base.column'">
                                    <xsl:text>Base?</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='arch_element.plinth'">
                                    <xsl:text>Base</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='base.altar'">
                                    <xsl:text>Base?</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='base.sculpture'">
                                    <xsl:text>Base?</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='block'">
                                    <xsl:text>Block</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='block.dedication'">
                                    <xsl:text>Block</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='block.building'">
                                    <xsl:text>Block</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='cippus.boundary-stone'">
                                    <xsl:text>Cippus</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='stele'">
                                    <xsl:text>Grave monument</xsl:text>
                                </xsl:when>
                                <!--                                    all #stele are applied to Tombstone: which one of the the two possible values in EDH do we want?-->

                                <xsl:when test="$denkmaltyp='tomb'">
                                    <xsl:text>Grave monument</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='instrumentum.incense-burner'">
                                    <xsl:text>Instrumentum sacrum</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='instrumentum.amulet'">
                                    <xsl:text>Instrumentum sacrum</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='milestone'">
                                    <xsl:text>Mile-/Leaguestone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='relief'">
                                    <xsl:text>Relief</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='sarcophagus'">
                                    <xsl:text>Sarcophagus</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='sculpture'">
                                    <xsl:text>Sculpture</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='slab'">
                                    <xsl:text>Slab</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='slab.building'">
                                    <xsl:text>Slab</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='slab.dedication'">
                                    <xsl:text>Slab</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='panel'">
                                    <xsl:text>Slab</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='panel.dedication'">
                                    <xsl:text>Slab</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='panel.slate'">
                                    <xsl:text>Slab?</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='plate'">
                                    <xsl:text>Slab</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='slab.altar'">
                                    <xsl:text>Slab?</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='statue'">
                                    <xsl:text>Statue</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='base.statue'">
                                    <xsl:text>Statue base</xsl:text>
                                </xsl:when>


                                <xsl:when test="$denkmaltyp='plaque'">
                                    <xsl:text>Table</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='tablet'">
                                    <xsl:text>Tabula</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='tablet.commemorative'">
                                    <xsl:text>Tabula</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='tablet.dedication'">
                                    <xsl:text>Tabula?</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='instrumentum.tessera'">
                                    <xsl:text>Tessera</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='Plank'">
                                    <xsl:text>Tile</xsl:text>
                                </xsl:when>

                                <xsl:when test="$denkmaltyp='urn'">
                                    <xsl:text>Urn</xsl:text>
                                </xsl:when>


                                <!-- EDH values not in use for this crosswalk
                                        
                                        <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Olla</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Paving stone</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Stele</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Shield</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Weapon</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Jewellery</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Herm</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Honorific/votive arch</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Honorific/votive column</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Instrumentum domesticum</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Instrumentum militare</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Cliff</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Cupa</xsl:text>
                                    </xsl:when> 
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Diptych</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Fortification</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Fountain</xsl:text>
                                    </xsl:when>         
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Bar</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Bench</xsl:text>
                                    </xsl:when>
                                    <xsl:when test="$denkmaltyp=''">
                                        <xsl:text>Bust</xsl:text>
                                    </xsl:when>
                                    -->
                            </xsl:choose>
                        </denkmaltyp>
                        <material>
                            <xsl:variable name="material">
                                <xsl:if test="$currentinscription//t:material">
                                    <xsl:sequence
                                        select="substring-after($currentinscription//t:material/@ana, '#')"
                                    />
                                </xsl:if>
                            </xsl:variable>
                            <xsl:choose>
                                <xsl:when test="$material='clay'">
                                    <xsl:text>Clay</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='clay.pipeclay'">
                                    <xsl:text>Clay</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='material_unknown'">
                                    <xsl:text>indefinite</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='metal.bronze'">
                                    <xsl:text>Bronze</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='metal.bronze.gilt'">
                                    <xsl:text>Bronze</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='metal.copper'">
                                    <xsl:text>Copper</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='metal.gold'">
                                    <xsl:text>Gold</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='metal.lead'">
                                    <xsl:text>Lead</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='metal.silver'">
                                    <xsl:text>Silver</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='metal.silver.gilt'">
                                    <xsl:text>Silver</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone'">
                                    <xsl:text>Rocks</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.conglomerate'">
                                    <xsl:text>Conglomerate</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.dolerite'">
                                    <xsl:text>Basalt</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.freestone'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.granite'">
                                    <xsl:text>Granite</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.greensand'">
                                    <xsl:text>Rocks</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.grit'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.grit.Millstone'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.grit.buff'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.grit.red'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.grit.reddish'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.igneous.fine-grained'">
                                    <xsl:text>Magmatic Rocks</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.lias.white'">
                                    <xsl:text>Rocks</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.limestone'">
                                    <xsl:text>Limestone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.limestone.buff.magnesian'">
                                    <xsl:text>Limestone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.marble'">
                                    <xsl:text>Marble (colour indefinite)</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.marble.Luna'">
                                    <xsl:text>Marble, veined / coloured</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.marble.Purbeck'">
                                    <xsl:text>Marble, veined / coloured</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.marble.black'">
                                    <xsl:text>Marble, veined / coloured</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.marble.coloured'">
                                    <xsl:text>Marble, veined / coloured</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.marble.green'">
                                    <xsl:text>Marble, veined / coloured</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.marble.white'">
                                    <xsl:text>Marble, white</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.metamorphic'">
                                    <xsl:text>Metamorphic Rocks</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.mudstone'">
                                    <xsl:text>Limestone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.oolite'">
                                    <xsl:text>Oolite</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.oolite.Bath'">
                                    <xsl:text>Oolite</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.other'">
                                    <xsl:text>Rocks</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.other.reddish'">
                                    <xsl:text>Rocks</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.Pennant'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.Rhaetic'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.buff'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.buff-or-lighter'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.calcareous'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.cream-coloured'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.cream-coloured.Manley'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.cream.Leuper'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.green'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.grey'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.greyish'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.light-coloured'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.micaceous'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.red'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.reddish'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.white'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.whitish'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.withish-buff'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.yellow'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.yellow-buff'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sandstone.yellowish-buff'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.sarsen'">
                                    <xsl:text>Sandstone</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.schist.gray'">
                                    <xsl:text>Metamorphic Rocks</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.slate'">
                                    <xsl:text>Slate</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.unknown'">
                                    <xsl:text>Rocks</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.unspecified'">
                                    <xsl:text>Rocks</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='stone.whinstone'">
                                    <xsl:text>Rocks</xsl:text>
                                </xsl:when>

                                <xsl:when test="$material='wood.oak'">
                                    <xsl:text>Wood</xsl:text>
                                </xsl:when>
                            </xsl:choose>
                            <!-- EDH values not used for this crosswalk as they do not have corresponding values
                                    
                 - Andesite
                 - Aplit
                 - Basalt
                 - Porphyry
                 - Syenite
            - Metamorphic Rocks
                 - Gneiss
                 - Marble (colour indefinite)
                 - Marble, white
                 - Marble, veined / coloured
                 - Quartzite
                 - Soapstone
            - Biological Sediments
                 - Carbonaceous Limestone
                 - Shell limestone
            - Chemical Sediments
                                  - Travertine
            - Clastic Sediments
                 - Breccia
                 - Calc-Sinter / Alabaster
                 - Calcareous Tuff
                 - Lime marl / marl
                - Molasse
            - Pyroclastic Sediments
                 - Nenfro
                 - Peperino
                 - Trachytes
                 - Volcanic Tuff
            - Minerals
                 - Agate
                 - Carnelian
                 - Haematite
                 - Heliotrope
                 - Jasper
                 - Lapislazuli
                 - Magnetite
                 - Onyx
                 - Opal
                 - Sardonyx
                 - Volcanic Tuff
        - Metals
            - indefinite
            - Brass
            - Iron
            - Tin
        - other materials / substances
            - Amber
            - Bone
            - Enamel
            - Glass
            - Ivory
            - Leather
            - Plaster
            - Stucco
            - Wax
        -->
                        </material>
                        <!--dimensions-->
                        <xsl:choose>
                            <xsl:when test="$currentinscription//t:msPart">

                                <xsl:for-each select="$currentinscription//t:msPart">
                                    <!--             needs to choose the higher area and insert those in cm with one decimal only for values up to 99cm-->

                                    <!--             TEST IF FRAGMENT IS PRESENT TO ADD - in front of values                   -->
                                    <frg n="{position()}">
                                        <xsl:if
                                            test="current()//t:support/t:dimensions[not(@n|@source)]//t:height">
                                            <hoehe>
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="current()//t:support/t:dimensions[not(@n|@source)]//t:height/@quantity">
                                                  <xsl:value-of
                                                  select="format-number(xs:decimal(current()//t:support/t:dimensions[not(@n|@source)]//t:height/@quantity) * 100, '-#.0')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="format-number(xs:decimal(current()//t:support/t:dimensions[not(@n|@source)]//t:height/@atMost) * 100, '-#.0')"
                                                  />
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </hoehe>
                                        </xsl:if>
                                        <xsl:if
                                            test="current()//t:support/t:dimensions[not(@n|@source)]//t:width">
                                            <breite>
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="current()//t:support/t:dimensions[not(@n|@source)]//t:width/@quantity">
                                                  <xsl:value-of
                                                  select="format-number(xs:decimal(current()//t:support/t:dimensions[not(@n|@source)]//t:width[1]/@quantity) * 100, '-#.0')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="format-number(xs:decimal(current()//t:support/t:dimensions[not(@n|@source)]//t:width/@atMost) * 100, '-#.0')"
                                                  />
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </breite>
                                        </xsl:if>
                                        <xsl:if
                                            test="current()//t:support/t:dimensions[not(@n|@source)]//t:depth/@quantity">
                                            <tiefe>
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="current()//t:support/t:dimensions[not(@n|@source)]//t:depth/@quantity">
                                                  <xsl:value-of
                                                  select="format-number(xs:decimal(current()//t:support/t:dimensions[not(@n|@source)]//t:depth/@quantity) * 100, '-#.0')"
                                                  />
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="format-number(xs:decimal(current()//t:support/t:dimensions[not(@n|@source)]//t:depth/@atMost) * 100, '-#.0')"
                                                  />
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </tiefe>
                                        </xsl:if>
                                    </frg>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:if
                                    test="$currentinscription//t:support/t:dimensions[not(@n|@source)]//t:height">
                                    <hoehe>
                                        <xsl:choose>
                                            <xsl:when
                                                test="$currentinscription//t:support/t:dimensions[not(@n|@source)]//t:height/@quantity">
                                                <xsl:value-of
                                                  select="format-number(xs:decimal($currentinscription//t:support/t:dimensions[not(@n|@source)]//t:height/@quantity) * 100, '#.0')"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="format-number(xs:decimal($currentinscription//t:support/t:dimensions[not(@n|@source)]//t:height/@atMost) * 100, '#.0')"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </hoehe>
                                </xsl:if>
                                <xsl:if
                                    test="$currentinscription//t:support/t:dimensions[not(@n|@source)]//t:width">
                                    <breite>
                                        <xsl:choose>
                                            <xsl:when
                                                test="$currentinscription//t:support/t:dimensions[not(@n|@source)]//t:width/@quantity">
                                                <xsl:value-of
                                                  select="format-number(xs:decimal($currentinscription//t:support/t:dimensions[not(@n|@source)]//t:width/@quantity) * 100, '#.0')"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="format-number(xs:decimal($currentinscription//t:support/t:dimensions[not(@n|@source)]//t:width/@atMost) * 100, '#.0')"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </breite>
                                </xsl:if>

                                <xsl:if
                                    test="$currentinscription//t:support/t:dimensions[not(@n|@source)]//t:depth/@quantity">
                                    <tiefe>
                                        <xsl:choose>
                                            <xsl:when
                                                test="$currentinscription//t:support/t:dimensions[not(@n|@source)]//t:depth/@quantity">
                                                <xsl:value-of
                                                  select="format-number(xs:decimal($currentinscription//t:support/t:dimensions[not(@n|@source)]//t:depth/@quantity) * 100, '#.0')"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="format-number(xs:decimal($currentinscription//t:support/t:dimensions[not(@n|@source)]//t:depth/@atMost) * 100, '#.0')"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </tiefe>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="$currentinscription//t:layout/t:dimensions/t:hight">
                            <bh>
                                <xsl:choose>
                                    <xsl:when
                                        test="$currentinscription//t:layout/t:dimensions/t:hight">
                                        <xsl:value-of
                                            select="format-number(xs:decimal($currentinscription//t:layout/t:dimensions/t:hight/@quantity) * 100, '-#.0')"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="format-number(xs:decimal($currentinscription//t:layout/t:dimensions/t:hight/@atMost) * 100, '-#.0')"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </bh>
                        </xsl:if>
                        <metrik>
                            <xsl:value-of select="$currentinscription//t:rs[@type='metre']"/>
                        </metrik>
                        <sprache>
                            <xsl:choose>
                                <xsl:when
                                    test="$currentinscription//t:div[@type='edition']/descendant-or-self::*[@xml:lang='grc']">
                                    <xsl:text>Greek</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="$currentinscription//t:div[@type='edition']/descendant-or-self::*[@xml:lang='la']">
                                    <xsl:text>Latin</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="$currentinscription//t:div[@type='edition']/descendant-or-self::*[@xml:lang='amw'][@n='Palmyrene']">
                                    <xsl:text>Palmyrenic</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="$currentinscription//t:div[@type='edition']/descendant-or-self::*[@xml:lang='cop']">
                                    <xsl:text>Coptic</xsl:text>
                                </xsl:when>
                                <xsl:when
                                    test="$currentinscription//t:div[@type='edition']/descendant-or-self::*[@xml:lang='ang']">
                                    <xsl:text>Celtic</xsl:text>
                                    <!--REALLY??-->
                                </xsl:when>


                                <xsl:otherwise>
                                    <xsl:text>Latin</xsl:text>
                                </xsl:otherwise>

                            </xsl:choose>
                        </sprache>

                        <xsl:variable name="dates">
                            <xsl:for-each select="$currentinscription//t:origDate">
                                <xsl:sequence select="."/>
                            </xsl:for-each>
                        </xsl:variable>

                        <xsl:if test="$currentinscription//t:origDate !=''">

                            <xsl:choose>
                                <xsl:when test="$currentinscription//t:origDate/@notBefore-custom">
                                    <datierung_von>
                                        <xsl:value-of
                                            select="$currentinscription//t:origDate/@notBefore-custom"
                                        />
                                    </datierung_von>
                                </xsl:when>
                            </xsl:choose>
                            <!--  can use in both format-date() to decide the output of the date-->

                            <xsl:choose>
                                <xsl:when test="$currentinscription//t:origDate/@notAfter-custom">

                                    <datierung_bis>
                                        <xsl:value-of
                                            select="$currentinscription//t:origDate/@notAfter-custom"
                                        />
                                    </datierung_bis>
                                </xsl:when>
                            </xsl:choose>

                        </xsl:if>

                        <xsl:if test="$currentinscription//t:rs[@type='socecon']">
                            <soziales>
                                <xsl:text>J</xsl:text>
                            </soziales>
                        </xsl:if>

                        <xsl:if test="$currentinscription//t:rs[@type='religion']">
                            <religion>
                                <xsl:if
                                    test="$currentinscription//t:rs[@type='religion']=('Jewish', 'Christian')">
                                    <xsl:text>2</xsl:text>
                                </xsl:if>
                                <xsl:if
                                    test="$currentinscription//t:rs[@type='religion'][@nymRef='priesthood']">
                                    <xsl:text>3</xsl:text>
                                </xsl:if>
                            </religion>
                        </xsl:if>

                        <xsl:if test="$currentinscription//t:div[@type='edition']//t:placeName">
                            <geographie>
                                <xsl:text>J</xsl:text>
                            </geographie>
                        </xsl:if>


                        <xsl:if
                            test="$currentinscription//t:div[@type='edition']//t:rs[@type='military']">
                            <militaer>
                                <xsl:text>J</xsl:text>
                            </militaer>
                        </xsl:if>

                        <beleg>provisional</beleg>
                        <bearbeiter>
                            <xsl:value-of select="$currentinscription//t:change[1]/@who"/>
                        </bearbeiter>
                        <datum>
                            <xsl:value-of select="$currentinscription//t:change[1]/@when"/>
                        </datum>
                        <lit>
                            <lit_line>
<!--                                <xsl:attribute name="href">
                                    <xsl:value-of
                                        select=" concat('http://romaninscriptionsofbritain.org/rib/inscriptions/', $currentinscription//t:idno[@type='rib'])"
                                    />
                                </xsl:attribute>-->
                                <xsl:if test="matches(.,'[a-z]')"><xsl:value-of
                                    select="concat('RIB ', format-number(number(substring-before(.,'[a-z]')), '0000'), matches(.,'[a-z]'), '.')"/>
                                </xsl:if>
                                <xsl:value-of
                                    select="concat('RIB ', format-number(., '0000'), '.')"/>
                            </lit_line>
                            <!--     <xsl:choose>
                        <xsl:when test="$currentinscription//t:div[@type='bibliography'][contains(., 'No bibliography')]">
                            <xsl:text>No Bibliography</xsl:text>
                    </xsl:when>
                      <xsl:otherwise>-->
                            <xsl:for-each
                                select="$currentinscription//t:div[@type='bibliography']//t:bibl[not(t:ref[@target='bibA00118']|t:ref[@target='bibA00263'])]">
                                <!--                        excludes EDH and Trismegistos from biblio-->

                                <xsl:if test="contains(.,'CIL')">
                                    <!--CIL-->
                                    <xsl:variable name="item">
                                        <xsl:choose>
                                            <xsl:when test=".//t:biblScope[@unit='pp']">
                                                <xsl:value-of select=".//t:biblScope[@unit='pp']"/>
                                            </xsl:when>
                                            <xsl:when test="matches(.//t:biblScope[@unit='item' and position()=1],'[a-z]')">
                                            <xsl:variable name="number">
                                                <xsl:analyze-string select=".//t:biblScope[@unit='item' and position() = 1]" regex="(\d+)">
                                                    <xsl:matching-substring><xsl:value-of select="regex-group(1)"/>
                                                    </xsl:matching-substring>    
                                                </xsl:analyze-string></xsl:variable>
                                            <xsl:variable name="letter">
                                                <xsl:analyze-string select=".//t:biblScope[@unit='item' and position() = 1]" regex="([a-z])">
                                            <xsl:matching-substring><xsl:value-of select="regex-group(1)"/>
                                            </xsl:matching-substring>    
                                            </xsl:analyze-string></xsl:variable>
                                            
                                            <xsl:value-of select="format-number($number, '00000')"/>
                                            <xsl:value-of select="$letter"/>
                                           </xsl:when>
                                        <xsl:otherwise><xsl:value-of
                                            select="format-number(number(.//t:biblScope[@unit='item' and position() = 1]), '00000')"
                                        /></xsl:otherwise></xsl:choose>
                                    </xsl:variable>
                                    <lit_line>
                                        <xsl:value-of select="concat('CIL ', '07, ', $item,'.')"/>
                                    </lit_line>
                                </xsl:if>
                                <xsl:if test="t:ref[@target='bibA00017']">
                                    <!--AE-->
                                    <xsl:variable name="year">
                                        <xsl:value-of select="t:date/@when"/>
                                    </xsl:variable>
                                    <lit_line>
                                        <xsl:value-of
                                            select="concat('AE ', $year, ', ', format-number(xs:integer(substring-after(t:biblScope[@unit='item'],'no. ')), '0000'),'.')"
                                        />
                                    </lit_line>
                                </xsl:if>

                                <!--                              WHAT TO DO WITH OTHER BIBLIOGRAPHY?  do we want it already? in IRT it was not imported
                                    -->
                            </xsl:for-each>
                            <!--</xsl:otherwise>
                    </xsl:choose>-->
                        </lit>

                        <kommentar>
                            <komm_line>
                                <!--                                <xsl:value-of select="$currentinscription//t:div[@type='commentary']/t:p"/>-->
                            </komm_line>
                        </kommentar>

                        <xsl:variable name="names">
                            <xsl:for-each
                                select="$currentinscription//t:div[@type='edition']//t:persName[not(@type='divine')]">
                                <xsl:variable name="me" select="generate-id()"/>
                                <xsl:if
                                    test="not(child::t:w[@lemma='diuus'][generate-id(ancestor::t:persName[1]) = $me]
                                    or descendant::t:w[@lemma='diuus'][generate-id(ancestor::t:persName[1]) = $me])">
                                    <xsl:if
                                        test="not(following-sibling::*[1][local-name()='w'][@lemma='filius' or @lemma='libertus' or @lemma='filia' or @lemma='liberta'] 
                                        and not(descendant::t:name[@type='gentilicium' or @type='cognomen']))">
                                        <xsl:sequence select="."/>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:if test="$names !=''">
                            <personen>
                                <xsl:for-each
                                    select="$names/t:persName[not(@type='divine')][descendant::t:name]">
                                    <xsl:variable name="namepos">
                                        <xsl:value-of select="position()"/>
                                    </xsl:variable>
                                    <person n="{position()}">
                                        <name>
                                            <xsl:variable name="namewithspaces">
                                                  <xsl:apply-templates select=".">
                                                  <xsl:with-param name="parm-leiden-style"
                                                  tunnel="yes">edh-names</xsl:with-param>
                                                  <xsl:with-param name="parm-line-inc"
                                                  select="$line-inc" tunnel="yes" as="xs:double"/>
                                                  </xsl:apply-templates>
                                                </xsl:variable>
                                                <xsl:value-of  select="normalize-space($namewithspaces)"/>
                                            
                                        </name>
                                        <praenomen>
                                            <xsl:variable name="praenomen">
                                                <xsl:if test=".//t:name[@type='praenomen'][@nymRef]">

                                                  <xsl:variable name="me" select="generate-id()"/>
                                                  <xsl:for-each
                                                  select=".//t:name[@type='praenomen'][@nymRef][generate-id(ancestor::t:persName[1]) = $me]">
                                                  <xsl:sequence
                                                  select="substring-after(./@nymRef,'#')"/>
                                                  </xsl:for-each>

                                                </xsl:if>
                                            </xsl:variable>
                                            <xsl:choose>
                                                <xsl:when test="$praenomen = 'Sextus'">
                                                    <xsl:text>Sex.</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="$praenomen = 'Gaius'">
                                                    <xsl:text>C.</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="$praenomen = 'Caius'">
                                                  <xsl:text>C.</xsl:text>
                                                </xsl:when>
                                                <!--                                     tokenize() the sequence? sequence retains xml values   double praenomen  if it ever happens  -->
                                                <xsl:when test="$praenomen = 'Cnaeus'">
                                                  <xsl:text>Cn.</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="$praenomen = 'Decimus'">
                                                  <xsl:text>D.</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="$praenomen = 'Lucius'">
                                                  <xsl:text>L.</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="$praenomen = 'Manius'">
                                                  <xsl:text>M'.</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="$praenomen = 'Marcus'">
                                                  <xsl:text>M.</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="$praenomen = 'Publius'">
                                                  <xsl:text>P.</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="$praenomen = 'Quintus'">
                                                  <xsl:text>Q.</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="$praenomen = 'Seruius'">
                                                  <xsl:text>Ser.</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="$praenomen = 'Tiberius'">
                                                  <xsl:text>Ti.</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="$praenomen = 'Titus'">
                                                  <xsl:text>T.</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:value-of select="$praenomen"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:choose>
                                                <xsl:when
                                                  test=".//t:name[@type='praenomen'][1][child::t:supplied[@reason='lost']] 
                                                or .//t:name[@type='praenomen'][1][descendant::t:supplied[@reason='lost']] 
                                                or .//t:name[@type='praenomen'][1][parent::t:supplied[@reason='lost']]
                                                or .//t:name[@type='praenomen'][1][ancestor::t:supplied[@reason='lost']]">
                                                  <xsl:text>+</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test=".//t:name[@type='praenomen'][1]/t:del 
                                                or .//t:name[@type='praenomen'][1]//t:del 
                                                or .//t:name[@type='praenomen'][1][parent::t:del]
                                                or .//t:name[@type='praenomen'][1][ancestor::t:del]">
                                                  <xsl:text>++</xsl:text>
                                                </xsl:when>
                                            </xsl:choose>
                                        </praenomen>
                                        <nomen>
                                            <xsl:if test=".//t:name[@type='gentilicium'][@nymRef]">
                                                <!-- Some RIB documents have more than one persNames with more than one nomen, which made the original code fail -->
                                                <xsl:analyze-string
                                                  select="(.//t:name[@type='gentilicium'])[1]/@nymRef"
                                                  regex="#">
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                                <xsl:choose>
                                                  <xsl:when
                                                  test=".//t:name[@type='gentilicium'][1]/t:supplied[@reason='lost'] 
                                                    or .//t:name[@type='gentilicium'][1]//t:supplied[@reason='lost'] 
                                                    or .//t:name[@type='gentilicium'][1][parent::t:supplied[@reason='lost']]
                                                    or .//t:name[@type='gentilicium'][1][ancestor::t:supplied[@reason='lost']]">
                                                  <xsl:text>+</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test=".//t:name[@type='gentilicium'][1]/t:del 
                                                    or .//t:name[@type='gentilicium'][1]//t:del 
                                                    or .//t:name[@type='gentilicium'][1][parent::t:del]
                                                    or .//t:name[@type='gentilicium'][1][ancestor::t:del]">
                                                  <xsl:text>++</xsl:text>
                                                  </xsl:when>
                                                </xsl:choose>
                                                <xsl:if
                                                    test=".//t:name[@type='gentilicium'][1]/t:expan or .//t:name[@type='gentilicium'][1]//t:expan">
                                                    <xsl:text>*</xsl:text>
                                                </xsl:if>
                                                
                                            </xsl:if>
                                        </nomen>
                                        <cognomen>
                                            <xsl:for-each
                                                select=".//t:name[@type='cognomen'][@nymRef][not(@nymRef =
                                            ('Adiabenicus','Alamannicus','Alanicus','Anticus','Arabicus','Armeniacus','Britannicus',
                                            'Carpicus','Dacicus','Francicus','Gallicus','Germanicus','Gipidicus','Gothicus','Herullicus',
                                            'Medicus','Palmyrenicus','Parthicus','Persicus','Pius','Sarmaticus','Vandalicus'))]">
                                                <xsl:analyze-string regex="#" select="@nymRef">
                                                  <xsl:non-matching-substring>
                                                  <xsl:value-of select="."/>
                                                  </xsl:non-matching-substring>
                                                </xsl:analyze-string>
                                               
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="child::t:supplied[@reason='lost'] 
                                                    or descendant::t:supplied[@reason='lost'] 
                                                    or parent::t:supplied[@reason='lost']
                                                    or ancestor::t:supplied[@reason='lost']">
                                                  <xsl:text>+</xsl:text>
                                                  </xsl:when>
                                                  <xsl:when
                                                  test="child::t:del 
                                                    or descendant::t:del 
                                                    or parent::t:del
                                                    or ancestor::t:del">
                                                  <xsl:text>++</xsl:text>
                                                  </xsl:when>
                                                </xsl:choose>
                                                <xsl:if test="child::t:expan or descendant::t:expan">
                                                    <xsl:text>*</xsl:text>
                                                </xsl:if>
                                                <xsl:if test="not(position()=last())">
                                                  <xsl:text> </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </cognomen>
                                        <supernomen>
                                            <xsl:for-each
                                                select=".//t:name[@type='supernomen'][@nymRef]">
                                                <xsl:value-of select="@nymRef"/>
                                                <xsl:if test="not(position()=last())">
                                                  <xsl:text> </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </supernomen>
                                        <tribus>
                                            <xsl:for-each
                                                select=".//t:orgName[@type='tribus']/t:name[@nymRef]">
                                                <xsl:value-of select="substring-after(@nymRef, '#')"/>
                                                <!--<xsl:if test="not(position()=last())">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>-->
                                                <xsl:choose>
                                                    <xsl:when
                                                        test="child::t:supplied[@reason='lost'] 
                                                        or descendant::t:supplied[@reason='lost'] 
                                                        or parent::t:supplied[@reason='lost']
                                                        or ancestor::t:supplied[@reason='lost']">
                                                        <xsl:text>+</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when
                                                        test="child::t:del 
                                                        or descendant::t:del 
                                                        or parent::t:del
                                                        or ancestor::t:del">
                                                        <xsl:text>++</xsl:text>
                                                    </xsl:when>
                                                </xsl:choose>
                                                <xsl:if test="child::t:expan or descendant::t:expan">
                                                    <xsl:text>*</xsl:text>
                                                </xsl:if>
                                                
                                            </xsl:for-each>
                                        </tribus>
                                        <origo/>
                                        <geschlecht>
                                            <xsl:choose>
                                                <xsl:when
                                                    test="ends-with(.//t:name[@type='praenomen' and parent::t:persName[not(descendant::t:persName) and position() =1]]/@nymRef, 'us') or ends-with(.//t:name[@type='gentilicium' and parent::t:persName[not(descendant::t:persName)]  and position() =1]/@nymRef, 'us') or ends-with(.//t:name[@type='cognomen' and parent::t:persName[not(descendant::t:persName)] and position() =1]/@nymRef, 'us')">
                                                  <xsl:text>M</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                    test="ends-with(.//t:name[@type='praenomen' and parent::t:persName[not(descendant::t:persName)] and position() =1]/@nymRef, 'a') or ends-with(.//t:name[@type='gentilicium' and parent::t:persName[not(descendant::t:persName)] and position() =1]/@nymRef, 'a') or ends-with(.//t:name[@type='cognomen' and parent::t:persName[not(descendant::t:persName)] and position() =1]/@nymRef, 'a')">
                                                  <xsl:text>W</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:text/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </geschlecht>
                                        <status>
                                            <xsl:choose>
                                                <xsl:when test="@type='imperial'">
                                                  <xsl:text>0</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="
                                                contains(@role, 'legatus') or 
                                                contains(@role, 'legate') or 
                                                contains(@role, 'governor') or 
                                                contains(@role, 'consul')">
                                                  <xsl:text>1</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="
                                                contains(@role, 'eques') 
                                                or contains(@role, 'aedile') 
                                                or contains(@role, 'procurator')">
                                                  <xsl:text>2</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="
                                                contains(@role, 'patronus') or 
                                                contains(@role, 'decurio') or 
                                                contains(@role, 'tribune')">
                                                  <xsl:text>3</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="
                                                contains(@role, 'medicus') or 
                                                contains(@role, 'magister') or 
                                                contains(@role, 'aerarius')">
                                                  <xsl:text>4</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="@role='sevir'">
                                                  <xsl:text>5</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="
                                                contains(@role, 'freedwoman') or 
                                                contains(@role, 'freedman') or 
                                                contains(@role, 'libertus')">
                                                  <xsl:text>6</xsl:text>
                                                </xsl:when>
                                                <xsl:when
                                                  test="
                                                contains(@role, 'beneficiarius') or 
                                                contains(@role, 'strator') or 
                                                contains(@role, 'miles') or 
                                                contains(@role, 'princeps-prior') or 
                                                contains(@role, 'veteranus') or 
                                                contains(@role, 'signifer') or 
                                                contains(@role, 'emeritus') or 
                                                contains(@role, 'vexillarius') or 
                                                contains(@role, 'imaginifer') or 
                                                contains(@role, 'tesserarius') or 
                                                contains(@role, 'actarius') or 
                                                contains(@role, 'armatura') or 
                                                contains(@role, 'optio') or 
                                                contains(@role, 'princeps') or 
                                                contains(@role, 'centurion')">
                                                  <xsl:text>9</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:text/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </status>
                                        <beruf>
                                            <xsl:if
                                                test="
                                            contains(@role, 'magister')">
                                                <xsl:text>J</xsl:text>
                                            </xsl:if>
                                        </beruf>
                                        <l_jahre/>
                                        <l_monate/>
                                        <l_tage/>
                                        <l_stunden/>
                                    </person>
                                </xsl:for-each>
                            </personen>
                        </xsl:if>
                        <textus>
                            <!--textparts-->
                            <xsl:variable name="text">
                                <xsl:choose>
                                    <xsl:when
                                        test="$currentinscription//t:div[@type='edition'][contains(., 'No text recorded')]">
                                        <xsl:text>No text recorded</xsl:text>
                                    </xsl:when>
                                    <xsl:when
                                        test="$currentinscription//t:div[@type='edition'][not(descendant::t:ab[@type='markup'])]">
                                        <xsl:for-each
                                            select="$currentinscription//t:div[@type='edition']/t:ab[@type]">
                                            <xsl:variable name="withbrackets">
                                                <xsl:apply-templates select=".">
                                                  <xsl:with-param name="parm-leiden-style"
                                                  tunnel="yes">edh-itx</xsl:with-param>
                                                  <xsl:with-param name="parm-line-inc"
                                                  select="$line-inc" tunnel="yes" as="xs:double"/>
                                                </xsl:apply-templates>
                                            </xsl:variable>
                                            <xsl:for-each select="$withbrackets">
                                                <xsl:call-template name="sqbrackets"/>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when
                                        test="$currentinscription//t:div[@type='edition']/t:div[@type='textpart']/t:ab[@type='markup']">

                                        <xsl:for-each
                                            select="$currentinscription//t:div[@type='edition']/t:div[@type='textpart']/t:ab[@type='markup']">
                                            <xsl:variable name="withbrackets">
                                                <xsl:apply-templates select=".">
                                                  <xsl:with-param name="parm-leiden-style"
                                                  tunnel="yes">edh-itx</xsl:with-param>
                                                  <xsl:with-param name="parm-line-inc"
                                                  select="$line-inc" tunnel="yes" as="xs:double"/>
                                                </xsl:apply-templates>
                                            </xsl:variable>
                                            <xsl:for-each select="$withbrackets">
                                                <xsl:call-template name="sqbrackets"/>
                                            </xsl:for-each>
                                            <xsl:if test="not(position() = last())">
                                                <xsl:text> // </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>

                                    <xsl:otherwise>
                                        <xsl:for-each
                                            select="$currentinscription//t:div[@type='edition']/t:ab[@type='markup']">
                                            <xsl:variable name="withbrackets">
                                                <xsl:apply-templates select=".">
                                                  <xsl:with-param name="parm-leiden-style"
                                                  tunnel="yes">edh-itx</xsl:with-param>
                                                  <xsl:with-param name="parm-line-inc"
                                                  select="$line-inc" tunnel="yes" as="xs:double"/>
                                                </xsl:apply-templates>
                                            </xsl:variable>
                                            <xsl:for-each select="$withbrackets">
                                                <xsl:call-template name="sqbrackets"/>
                                            </xsl:for-each>
                                        </xsl:for-each>

                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:value-of select="normalize-space($text)"/>
                        </textus>
                    </record>
                </xsl:if>
            </xsl:for-each>

        </EDH>
    </xsl:template>

    <xsl:template match="t:rs[@type='dimensions']">
        <xsl:for-each select="t:measure">
            <xsl:if test="not(last())">
                <xsl:value-of select="."/>
                <xsl:text> x </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="t:head"/>

</xsl:stylesheet>
