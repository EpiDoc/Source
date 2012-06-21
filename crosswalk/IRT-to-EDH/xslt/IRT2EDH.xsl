<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <!-- 
     IRT - generate table for EDH
     RV 07-07-2009 ; GB 2009-12-08
     latest revision: 2012-06-21 GB
     note: run on ../xml-in/tables/inscriptions.xml
     *note:* must first have run Edition2EDH and Names2EDN
-->

    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="IRT_texts" select="'../../xml/edh/edh-texts.xml'"/>
    <xsl:variable name="IRT_names" select="'../../xml/edh/edh-names.xml'"/>
    
    <xsl:template match="/">

        <EDH>
            <xsl:for-each select="//file">
                <xsl:if
                    test="not(document('../../xml/edh/edh-and-irt.xml')//irt[. = substring-before(current(),'.xml')])">
                    <xsl:variable name="filename" select="concat('../../xml/workspace/',.)"/>
                    <xsl:for-each select="document($filename)//TEI.2">
                        <record id="{@id}">
                            <provinz>
                                <xsl:value-of select="//geogName[@type='ancientRegion']/@key"/>
                            </provinz>
                            <land>
                                <xsl:value-of
                                    select="lower-case(//geogName[@type='modernCountry']/@key)"/>
                            </land>
                            <fo_antik pleiades="{//placeName[@type='ancientFindspot']/@key}">
                                <xsl:value-of select="//placeName[@type='ancientFindspot']"/>
                            </fo_antik>
                            <fo_modern geonames="//placeName[@type='modernFindspot']/@key">
                                <xsl:value-of select="//placeName[@type='modernFindspot']"/>
                            </fo_modern>
                            <fundjahr>
                                <xsl:if test="number(//date[@type='foundDate'][1])">
                                    <xsl:value-of select="//date[@type='foundDate'][1]"/>
                                </xsl:if>
                            </fundjahr>
                            <fundstelle>
                                <xsl:variable name="findspot">
                                    <xsl:apply-templates select="//rs[@type='found']"/>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="starts-with(normalize-space($findspot),':')">
                                        <xsl:value-of
                                            select="normalize-space(substring-after(normalize-space($findspot),':'))"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="normalize-space($findspot)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fundstelle>
                            <aufbewahrung>
                                <xsl:if
                                    test="not(starts-with(//rs[@type='lastLocation'],'Findspot'))">
                                    <xsl:value-of select="//rs[@type='lastLocation']"/>
                                </xsl:if>
                            </aufbewahrung>
                            <dekor>
                                <xsl:if test="//rs[@type='decoration']">
                                    <xsl:text>J</xsl:text>
                                </xsl:if>
                            </dekor>
                            <i_gattung>
                                <xsl:value-of select="//rs[@type='textType']/@key"/>
                            </i_gattung>
                            <denkmaltyp>
                                <xsl:value-of select="//rs[@type='objectType']/@key"/>
                            </denkmaltyp>
                            <material>
                                <xsl:value-of select="//rs[@type='material']"/>
                            </material>

                            <xsl:variable name="rss">
                                <xsl:for-each
                                    select="//div[@type='description'][@subtype='monument']//rs[@type='dimensions']">
                                    <xsl:sequence select="."/>
                                </xsl:for-each>
                            </xsl:variable>
                            <hoehe>
                                <xsl:choose>
                                    <xsl:when test="number($rss/rs[1]//measure[@dim='height'][1])">
                                        <xsl:value-of
                                            select="number($rss/rs[1]//measure[@dim='height'][1]) * 100"/>
                                    </xsl:when>
                                    <xsl:when test="number($rss/rs[1]//measure[@dim='height'][1]/@from)">
                                        <xsl:value-of
                                            select="number($rss/rs[1]//measure[@dim='height'][1]/@from) * 100"
                                        />
                                    </xsl:when>
                                </xsl:choose>
                            </hoehe>
                            <breite>
                                <xsl:choose>
                                    <xsl:when test="number($rss/rs[1]//measure[@dim='width'][1])">
                                        <xsl:value-of
                                            select="number($rss/rs[1]//measure[@dim='width'][1]) * 100"/>
                                    </xsl:when>
                                    <xsl:when test="number($rss/rs[1]//measure[@dim='width'][1]/@from)">
                                        <xsl:value-of
                                            select="number($rss/rs[1]//measure[@dim='width'][1]/@from) * 100"
                                        />
                                    </xsl:when>
                                </xsl:choose>
                            </breite>
                            <tiefe>
                                <xsl:choose>
                                    <xsl:when test="number($rss/rs[1]//measure[@dim='depth'][1])">
                                        <xsl:value-of
                                            select="number($rss/rs[1]//measure[@dim='depth'][1]) * 100"/>
                                    </xsl:when>
                                    <xsl:when test="number($rss/rs[1]//measure[@dim='depth'][1]/@from)">
                                        <xsl:value-of
                                            select="number($rss/rs[1]//measure[@dim='depth'][1]/@from) * 100"
                                        />
                                    </xsl:when>
                                </xsl:choose>
                            </tiefe>

                            <bh>
                                <xsl:variable name="letterh">
                                    <xsl:for-each
                                        select="//div[@type='description'][@subtype='letters'][1]//measure[@dim='height'][1]">
                                        <xsl:sequence select="."/>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:choose>
                                    <xsl:when test="number($letterh//measure[1])">
                                        <xsl:value-of select="number($letterh//measure[1]) * 100"/>
                                    </xsl:when>
                                    <xsl:when test="$letterh//measure[1][@from]">
                                        <xsl:value-of select="number($letterh//measure[1]/@from) * 100"/>
                                    </xsl:when>
                                </xsl:choose>
                            </bh>
                            <metrik>
                                <xsl:if test="//div[@type='edition']//lg">
                                    <xsl:text>J</xsl:text>
                                </xsl:if>
                            </metrik>
                            <nl_text>
                                <xsl:if
                                    test="//div[@type='edition']/descendant-or-self::*[@lang='grc']">
                                    <xsl:text>A</xsl:text>
                                </xsl:if>
                            </nl_text>

                            <xsl:variable name="dates">
                                <xsl:for-each select="//date[@type='textDate']">
                                    <xsl:sequence select="."/>
                                </xsl:for-each>
                            </xsl:variable>
                            <dat_tag>
                                <xsl:if
                                    test="matches($dates/date[1]/@value, '-?\d{1,4}-\d{2}-\d{2}')">
                                    <xsl:value-of
                                        select="replace($dates/date[1]/@value, '-?\d{1,4}-\d{2}-(\d{2})', '$1')"
                                    />
                                </xsl:if>
                            </dat_tag>
                            <dat_monat>
                                <xsl:if
                                    test="matches($dates/date[1]/@value, '-?\d{1,4}-\d{2}(-\d{2})?')">
                                    <xsl:value-of
                                        select="replace($dates/date[1]/@value, '-?\d{1,4}-(\d{2})(-\d{2})?', '$1')"
                                    />
                                </xsl:if>
                            </dat_monat>
                            <dat_jahr_a>
                                <xsl:if
                                    test="matches($dates/date[1]/@value, '-?\d{1,4}(-\d{2})?(-\d{2})?')">
                                    <xsl:value-of
                                        select="replace($dates/date[1]/@value, '(-?\d{1,4})(-\d{2})?(-\d{2})?', '$1')"
                                    />
                                </xsl:if>
                            </dat_jahr_a>

                            <soziales>
                                <xsl:if test="//rs[@type='socecon']">
                                    <xsl:text>J</xsl:text>
                                </xsl:if>
                            </soziales>
                            <religion>
                                <xsl:if test="//rs[@type='religion']=('Jewish', 'Christian')">
                                    <xsl:text>2</xsl:text>
                                </xsl:if>
                                <xsl:if test="//rs[@type='religion'][@reg='priesthood']">
                                    <xsl:text>3</xsl:text>
                                </xsl:if>
                            </religion>
                            <geographie>
                                <xsl:if test="//div[@type='edition']//placeName">
                                    <xsl:text>J</xsl:text>
                                </xsl:if>
                            </geographie>
                            <militaer>
                                <xsl:if test="//div[@type='edition']//rs[@type='military']">
                                    <xsl:text>J</xsl:text>
                                </xsl:if>
                            </militaer>
                            <beleg/>
                            <bearbeiter/>
                            <datum/>
                            <lit_line>
                                <xsl:value-of select="substring(@id,1,3)"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="substring-after(@id,'IRT')"/>
                                <xsl:text>.</xsl:text>
                            </lit_line>
                            <komm_line>
                                <xsl:if
                                    test="not(starts-with(//div[@type='commentary'][1]/p[1],'No comment'))">
                                    <xsl:apply-templates select="//div[@type='commentary']"/>
                                </xsl:if>
                                <xsl:if test="$rss/rs[2]">
                                    <xsl:for-each
                                        select="//div[@type='description'][@subtype='monument']//p/node()">
                                        <xsl:choose>
                                            <xsl:when test="self::rs[@type='dimensions']">
                                                <xsl:for-each select="measure">

                                                  <xsl:value-of select="."/>
                                                  <xsl:if test="not(position()=last())">
                                                  <xsl:text> x </xsl:text>
                                                  </xsl:if>

                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="."/>
                                            </xsl:otherwise>
                                        </xsl:choose>

                                    </xsl:for-each>
                                </xsl:if>
                            </komm_line>
                            <xsl:variable name="names">
                                <xsl:for-each
                                    select="//div[@type='edition']//persName[not(@type='divine')]">
                                    <xsl:variable name="me" select="generate-id()"/>
                                    <xsl:if test="not(child::w[@lemma='diuus'][generate-id(ancestor::persName[1]) = $me]
                                        or descendant::w[@lemma='diuus'][generate-id(ancestor::persName[1]) = $me])">
                                        <xsl:if test="not(following-sibling::*[1][local-name()='w'][@lemma='filius' or @lemma='libertus' or @lemma='filia' or @lemma='liberta'] 
                                            and not(descendant::name[@type='gentilicium' or @type='cognomen']))">
                                    <xsl:sequence select="."/>
                                    </xsl:if></xsl:if>
                                </xsl:for-each>
                            </xsl:variable>
                            <xsl:variable name="currid">
                                <xsl:value-of select="@id"/>
                            </xsl:variable>
                            <xsl:for-each
                                select="$names/persName[not(@type='divine')][descendant::name]">
                                <xsl:variable name="namepos">
                                    <xsl:value-of select="position()"/>
                                </xsl:variable>
                                <Namen n="{position()}">
                                    <name>
                                        <xsl:value-of
                                            select="normalize-space(translate(document($IRT_names)//text[@id=$currid]/name[position()
                                        = $namepos],'/',''))"
                                        />
                                    </name>
                                    <praenomen>
                                        <xsl:variable name="praenomen">
                                            <xsl:if test=".//name[@type='praenomen'][@reg]">
                                                <xsl:variable name="names">
                                                  <xsl:variable name="me" select="generate-id()"/>
                                                  <xsl:for-each
                                                  select=".//name[@type='praenomen'][@reg][generate-id(ancestor::persName[1]) = $me]">
                                                  <xsl:sequence select="."/>
                                                  </xsl:for-each>
                                                </xsl:variable>
                                                <xsl:value-of select="$names/*[1]/@reg"/>
                                            </xsl:if>
                                        </xsl:variable>
                                        <xsl:choose>
                                            <xsl:when test="$praenomen = 'Caius'">
                                                <xsl:text>C.</xsl:text>
                                            </xsl:when>
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
                                            <xsl:when test=".//name[@type='praenomen'][1][child::supplied[@reason='lost']] 
                                                or .//name[@type='praenomen'][1][descendant::supplied[@reason='lost']] 
                                                or .//name[@type='praenomen'][1][parent::supplied[@reason='lost']]
                                                or .//name[@type='praenomen'][1][ancestor::supplied[@reason='lost']]">
                                                <xsl:text>+</xsl:text>
                                            </xsl:when>
                                            <xsl:when test=".//name[@type='praenomen'][1]/del 
                                                or .//name[@type='praenomen'][1]//del 
                                                or .//name[@type='praenomen'][1][parent::del]
                                                or .//name[@type='praenomen'][1][ancestor::del]">
                                                <xsl:text>++</xsl:text>
                                            </xsl:when>
                                        </xsl:choose>
                                    </praenomen>
                                    <nomen>
                                        <xsl:if test=".//name[@type='gentilicium'][@reg]">
                                            <xsl:value-of
                                                select=".//name[@type='gentilicium'][1]/@reg"/>
                                            <xsl:if test=".//name[@type='gentilicium'][1]/expan or .//name[@type='gentilicium'][1]//expan">
                                                <xsl:text>*</xsl:text>
                                            </xsl:if>
                                            <xsl:choose>
                                                <xsl:when test=".//name[@type='gentilicium'][1]/supplied[@reason='lost'] 
                                                    or .//name[@type='gentilicium'][1]//supplied[@reason='lost'] 
                                                    or .//name[@type='gentilicium'][1][parent::supplied[@reason='lost']]
                                                    or .//name[@type='gentilicium'][1][ancestor::supplied[@reason='lost']]">
                                                    <xsl:text>+</xsl:text>
                                                </xsl:when>
                                                <xsl:when test=".//name[@type='gentilicium'][1]/del 
                                                    or .//name[@type='gentilicium'][1]//del 
                                                    or .//name[@type='gentilicium'][1][parent::del]
                                                    or .//name[@type='gentilicium'][1][ancestor::del]">
                                                    <xsl:text>++</xsl:text>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:if>
                                    </nomen>
                                    <cognomen>
                                        <xsl:for-each select=".//name[@type='cognomen'][@reg][not(@reg =
                                            ('Adiabenicus','Alamannicus','Alanicus','Anticus','Arabicus','Armeniacus','Britannicus',
                                            'Carpicus','Dacicus','Francicus','Gallicus','Germanicus','Gipidicus','Gothicus','Herullicus',
                                            'Medicus','Palmyrenicus','Parthicus','Persicus','Pius','Sarmaticus','Vandalicus'))]">
                                            <xsl:value-of select="@reg"/>
                                            <xsl:if test="child::expan or descendant::expan">
                                                <xsl:text>*</xsl:text>
                                            </xsl:if>
                                            <xsl:choose>
                                                <xsl:when test="child::supplied[@reason='lost'] 
                                                    or descendant::supplied[@reason='lost'] 
                                                    or parent::supplied[@reason='lost']
                                                    or ancestor::supplied[@reason='lost']">
                                                    <xsl:text>+</xsl:text>
                                                </xsl:when>
                                                <xsl:when test="child::del 
                                                    or descendant::del 
                                                    or parent::del
                                                    or ancestor::del">
                                                    <xsl:text>++</xsl:text>
                                                </xsl:when>
                                            </xsl:choose>
                                            <xsl:if test="not(position()=last())">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </cognomen>
                                    <supernomen>
                                        <xsl:for-each select=".//name[@type='supernomen'][@reg]">
                                            <xsl:value-of select="@reg"/>
                                            <xsl:if test="not(position()=last())">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </supernomen>
                                    <tribus>
                                        <xsl:for-each select=".//name[@type='tribe'][@reg]">
                                            <xsl:value-of select="@reg"/>
                                            <xsl:if test="not(position()=last())">
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </tribus>
                                </Namen>
                            </xsl:for-each>
                            <origo/>
                            <geschlecht/>
                            <status/>
                            <beruf/>
                            <l_jahre/>
                            <l_monate/>
                            <l_tage/>
                            <l_stunden/>
                            <textus>
                                <xsl:value-of
                                    select="normalize-space(document($IRT_texts)//text[@id=current()/@id]/textus)"
                                />
                            </textus>
                        </record>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>
        </EDH>
    </xsl:template>

    <xsl:template match="rs[@type='dimensions']">
        <xsl:for-each select="measure">
            <xsl:if test="not(last())">
                <xsl:value-of select="."/>
                <xsl:text> x </xsl:text>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="head"/>

    <xsl:template match="xref[@type='inscription']">
        <xsl:text>IRT </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="placeName[@type='ancientFindspot']"/>

</xsl:stylesheet>
