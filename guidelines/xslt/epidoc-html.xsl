<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:s="http://www.ascc.net/xml/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:t="http://www.thaiopensource.com/ns/annotations"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    exclude-result-prefixes="tei t a rng s teix"
    version="2.0">
    
    <xsl:import href="TEI-Stylesheets/odds/odd2html.xsl"/>
    <!--<xsl:import href="http://www.tei-c.org/release/xml/tei/stylesheet/odds2/odd2html.xsl"/>-->
    <!-- <xsl:import href="/Applications/oxygen/frameworks/tei/xml/tei/stylesheet/odds2/odd2html.xsl"/> -->
    <!-- <xsl:import href="../../example-p5-xslt/htm-imports.xsl"/> -->
    <xsl:import href="elementsIndex.xsl"/>
    <xsl:import href="render-epidoc.xsl"/>
    <xsl:import href="tpl-analytic.xsl"/>
    <xsl:import href="tpl-search.xsl"/>
    
    <xsl:output encoding="utf-8" method="xhtml" indent="no"/>
    <xsl:param name="STDOUT">false</xsl:param>
    <xsl:param name="splitLevel">0</xsl:param>
    <xsl:param name="autoToc">false</xsl:param>
    <xsl:param name="cssFile">css/epidoc.css</xsl:param>
    <xsl:param name="cssSecondaryFile">css/epidoc-odd.css</xsl:param>
    <xsl:param name="TEIC">true</xsl:param>
    <xsl:param name="forceWrap">false</xsl:param>
    <xsl:param name="analytics">off</xsl:param>
    <!--<xsl:param name="googleAnalytics">UA-43203560-1</xsl:param>-->

    <xsl:template name="egXMLEndHook">
        <xsl:call-template name="render-epidoc"/>
        <!--<xsl:element name="br"/>-->
        <xsl:if test="@corresp">
            <div class="rend">
                 <xsl:text>(</xsl:text>
                 <xsl:element name="span">
                     <xsl:attribute name="class">
                         <xsl:text>ref</xsl:text>
                     </xsl:attribute>
                     <xsl:choose>
                         <xsl:when test="starts-with(@corresp, 'http://insaph.kcl.ac.uk/iaph2007/')">
                             <xsl:text>InsAph: </xsl:text>
                             <xsl:variable name="filename">
                                 <xsl:value-of
                                     select="substring-before(substring-after(@corresp,'http://insaph.kcl.ac.uk/iaph2007/iAph'),'.html')"
                                 />
                             </xsl:variable>
                             <xsl:element name="a">
                                 <xsl:attribute name="href" select="@corresp"/>
                                 <xsl:value-of select="number(substring($filename,1,2))"/>
                                 <xsl:text>.</xsl:text>
                                 <xsl:value-of select="number(substring($filename,3,4))"/>
                             </xsl:element>
                         </xsl:when>
                         <xsl:when test="starts-with(@corresp, 'http://insaph.kcl.ac.uk/ala2004/')">
                             <xsl:text>ALA: </xsl:text>
                             <xsl:variable name="filename">
                                 <xsl:value-of
                                     select="substring-before(substring-after(@corresp,'http://insaph.kcl.ac.uk/ala2004/inscription/eAla'),'.html')"
                                 />
                             </xsl:variable>
                             <xsl:element name="a">
                                 <xsl:attribute name="href" select="@corresp"/>
                                 <xsl:value-of select="number($filename)"/>
                             </xsl:element>
                         </xsl:when>
                         <xsl:when test="starts-with(@corresp, 'http://inslib.kcl.ac.uk/irt2009/')">
                             <xsl:text>IRT: </xsl:text>
                             <xsl:variable name="filename">
                                 <xsl:value-of
                                     select="substring-before(substring-after(@corresp,'http://inslib.kcl.ac.uk/irt2009/IRT'),'.html')"
                                 />
                             </xsl:variable>
                             <xsl:element name="a">
                                 <xsl:attribute name="href" select="@corresp"/>
                                 <xsl:value-of select="number(translate($filename,'abcdefghi',''))"/>
                                 <xsl:value-of select="translate($filename,'0123456789','')"/>
                             </xsl:element>
                         </xsl:when>
                         <xsl:when test="starts-with(@corresp, 'http://papyri.info/ddbdp/')">
                             <xsl:text>DDbDP: </xsl:text>
                             <xsl:variable name="filename" select="substring-after(@corresp,'http://papyri.info/ddbdp/')"/>
                             <xsl:element name="a">
                                 <xsl:attribute name="href" select="@corresp"/>
                                 <xsl:value-of select="translate($filename,';','.')"/>
                             </xsl:element>
                         </xsl:when>
                         <xsl:when test="starts-with(@corresp,'http://epigraphy.packhum.org')">
                             <xsl:text>PHI: </xsl:text>
                             <xsl:variable name="filename" select="substring-after(@corresp,'http://epigraphy.packhum.org/inscriptions/oi?ikey=')"/>
                             <xsl:element name="a">
                                 <xsl:attribute name="href" select="@corresp"/>
                                 <xsl:value-of select="$filename"/>
                             </xsl:element>
                         </xsl:when>
                         <xsl:when test="starts-with(@corresp,'http://edh-www.adw.uni-heidelberg.de/edh/inschrift')">
                             <xsl:text>EDH: </xsl:text>
                             <xsl:variable name="filename" select="substring-after(@corresp,'http://edh-www.adw.uni-heidelberg.de/edh/inschrift/')"/>
                             <xsl:element name="a">
                                 <xsl:attribute name="href" select="@corresp"/>
                                 <xsl:value-of select="$filename"/>
                             </xsl:element>
                         </xsl:when>
                          <xsl:when test="starts-with(@corresp, 'http://romaninscriptionsofbritain.org/inscriptions/')">
                             <xsl:text>RIB: </xsl:text>
                             <xsl:variable name="filename" select="substring-after(@corresp,'http://romaninscriptionsofbritain.org/inscriptions/')"/>
                             <xsl:element name="a">
                                 <xsl:attribute name="href" select="@corresp"/>
                                 <xsl:value-of select="$filename"/>
                             </xsl:element>
                         </xsl:when>
                         <xsl:when test="starts-with(@corresp, 'https://igcyr.unibo.it/gvcyr')">
                             <xsl:text>GVCyr: </xsl:text>
                             <xsl:variable name="filename" select="substring-after(@corresp,'https://igcyr.unibo.it/')"/>
                             <xsl:element name="a">
                                 <xsl:attribute name="href" select="@corresp"/>
                                 <xsl:value-of select="$filename"/>
                             </xsl:element>
                         </xsl:when>
                         <xsl:when test="starts-with(@corresp, 'https://igcyr.unibo.it/igcyr')">
                             <xsl:text>IGCyr: </xsl:text>
                             <xsl:variable name="filename" select="substring-after(@corresp,'https://igcyr.unibo.it/')"/>
                             <xsl:element name="a">
                                 <xsl:attribute name="href" select="@corresp"/>
                                 <xsl:value-of select="$filename"/>
                             </xsl:element>
                         </xsl:when>
                         <xsl:when test="starts-with(@corresp,'#') and //tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]">
                             <xsl:for-each select="//tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]/tei:author">
                                 <xsl:value-of select="if(tei:name) then tei:name else ."/>
                                 <xsl:if test="following-sibling::tei:author">
                                     <xsl:text>/</xsl:text>
                                 </xsl:if>
                             </xsl:for-each>
                         </xsl:when>
                        <xsl:otherwise>
                             <xsl:element name="a">
                                 <xsl:attribute name="href" select="@corresp"/>
                                 <xsl:text>Source</xsl:text>
                             </xsl:element>
                         </xsl:otherwise>
                     </xsl:choose>
                 </xsl:element>
                 <xsl:text>)</xsl:text>
            </div>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:specList">
        <ul class="speclit">
            <xsl:for-each select="tei:specDesc">
                <li>TEI definition: <a
                        href="http://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-{@key}.html">
                        <xsl:value-of select="@key"/>
                    </a>
                    <xsl:if test="//tei:elementSpec[@ident=current()/@key]"> ; EpiDoc-specific
                        customization: <a href="ref-{@key}.html">
                            <xsl:value-of select="@key"/>
                        </a>
                    </xsl:if>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>
    
    <xsl:template match="tei:cit">
        <xsl:element name="p">
            <xsl:element name="strong">
                <xsl:apply-templates select="tei:bibl"/>
                <xsl:text>: </xsl:text>
            </xsl:element>
            <xsl:apply-templates select="tei:quote"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:cit/tei:bibl">
        <xsl:choose>
            <xsl:when test="starts-with(@corresp,'#') and //tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]">
                    <xsl:element name="a">
                        <xsl:attribute name="class" select="'glossary'"/>
                        <xsl:attribute name="href">
                            <xsl:text>app-bibliography.html</xsl:text>
                            <xsl:value-of select="@corresp"/>
                        </xsl:attribute>
                        <xsl:attribute name="title">
                            <xsl:value-of select="normalize-space(//tei:bibl[@xml:id = substring-after(current()/@corresp, '#')])"/>
                        </xsl:attribute>
                    <xsl:choose>
                        <xsl:when test="//tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]/tei:author/tei:name[@type='surname']">
                            <xsl:for-each select="//tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]/tei:author">
                                <xsl:value-of select="tei:name[@type='surname']"/>
                                <xsl:if test="following-sibling::tei:author">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="//tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]/tei:author">
                            <xsl:for-each select="//tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]/tei:author">
                                <xsl:value-of select="."/>
                                <xsl:if test="following-sibling::tei:author">
                                    <xsl:text>/</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="//tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]/tei:title[1]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="//tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]/tei:date">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="//tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]/tei:date[1]"/>
                    </xsl:if>
                 </xsl:element>
            </xsl:when>
            <xsl:when test="starts-with(@corresp,'#') and not(//tei:bibl[@xml:id = substring-after(current()/@corresp, '#')])">
                <xsl:text>according to </xsl:text>
                <xsl:value-of select="substring-after(current()/@corresp, '#')"/>
            </xsl:when>
        </xsl:choose>
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::tei:bibl"><xsl:text>; </xsl:text></xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:cit/tei:bibl/tei:biblScope">
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    
    
    <xsl:template match="tei:cit/tei:quote">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:respStmt">
        <xsl:apply-templates select="tei:name"/>, <xsl:apply-templates select="tei:resp"/><xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template name="formatHeadingNumber">
        <xsl:param name="text"/>
        <xsl:param name="toc"/>
    </xsl:template>
    
    <xsl:template match="tei:term[@target]">
        <xsl:element name="a">
            <xsl:attribute name="class" select="'glossary'"/>
            <xsl:if test="//tei:*/@xml:id = substring-after(current()/@target,'#')">
                <xsl:attribute name="href">
                    <xsl:value-of select="//tei:*[@xml:id=substring-after(current()/@target,'#')][1]/ancestor::tei:div[parent::tei:body]/@xml:id"/>
                    <xsl:text>.html</xsl:text>
                    <xsl:value-of select="@target"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="title">
                <xsl:choose>
                    <xsl:when test="//tei:label/@xml:id = substring-after(current()/@target,'#')">
                        <xsl:value-of select="normalize-space(//tei:label[@xml:id = substring-after(current()/@target,'#')][1])"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="normalize-space(//tei:label[@xml:id = substring-after(current()/@target,'#')][1]/following-sibling::tei:item[1])"/>
                    </xsl:when>
                    <xsl:when test="//tei:bibl/@xml:id = substring-after(current()/@target,'#')">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="normalize-space(//tei:bibl[@xml:id = substring-after(current()/@target,'#')])"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:divGen[@type='seealso']">
        <xsl:variable name="curpage" select="generate-id(ancestor::tei:div[parent::tei:body])"/>
        <xsl:variable name="curid" select="ancestor::tei:div[parent::tei:body]/@xml:id"/>
        <div class="seealso">
            <h3>See also:</h3>
            <xsl:for-each select="ancestor::tei:div[parent::tei:body]//tei:specList/tei:specDesc">
                <p>Other pages describing &lt;<xsl:value-of select="@key"/>&gt;:</p>
                    <ul>
                        <xsl:for-each select="ancestor::tei:body/tei:div[generate-id() != $curpage]//tei:specList/tei:specDesc[@key = current()/@key]">
                            <xsl:variable name="instanceid" select="ancestor::tei:div[parent::tei:body]/@xml:id"/>
                            <xsl:if test="ancestor::tei:body/tei:div[generate-id() != $curpage]//tei:specList/tei:specDesc[@key = current()/@key]
                            and (
                            (contains($curid,'-pt-br') and contains($instanceid,'-pt-br'))
                            or
                            (not(contains($curid,'-pt-br')) and not(contains($instanceid,'-pt-br')))
                            )">
                        <li>
                            <a href="{concat(ancestor::tei:div[parent::tei:body]/@xml:id,'.html')}">
                                <xsl:value-of select="ancestor::tei:div[parent::tei:body]/tei:head[1]"/>
                            </a>
                        </li>
                        </xsl:if>
                    </xsl:for-each>
                </ul>
             
            </xsl:for-each>
        </div>
    </xsl:template>
    
   
        <xsl:template match="tei:divGen[@type='chardecl']">
        <!--        imports in variable charDecl from Stylesheets repository-->
        <xsl:variable name="chardecl" select="doc('../../example-p5-xslt/charDecl.xml')"/>
        <xsl:variable name="g-">
            <xsl:for-each select="distinct-values($chardecl//tei:glyph/t:mapping/@type)">
                <xsl:sort select="."/>
                <g><xsl:value-of select="."/></g>
            </xsl:for-each>
        </xsl:variable>
        <div class="chardecl">
            
            <table>
                <thead>
                    <tr>
                        <th>xml:id</th>
                        <xsl:for-each select="$g-/g">
                            <th><xsl:value-of select="."/></th>
                        </xsl:for-each>
                    </tr>
                </thead>
                <tbody>
                    <xsl:for-each select="$chardecl//tei:glyph">
                        <xsl:variable name="glyph" select="."/>
                        <tr>
                            <td><xsl:value-of select="@xml:id"/></td>
                            <xsl:for-each select="$g-/g">
                                <xsl:variable name="text" select="./text()"/>
                                <td><xsl:if test="$glyph/tei:mapping[@type=$text]"><xsl:value-of select="$glyph/tei:mapping[@type=$text]/text()"/></xsl:if></td>
                            </xsl:for-each>
                        </tr>
                    </xsl:for-each>
                    
                </tbody>
            </table>
            
        </div>
    </xsl:template>
    
    <xsl:template name="javascriptHook">
        <!-- overriding template in Sebastian's XSLT in order to import Google Analytics code -->
        <!-- the $analytics parameter (above) is "off" by default,
            but should be temporarily set to "on" in the Oxygen scenario when making a final, "day zero" release -->
        <xsl:if test="$analytics='on'"><xsl:call-template name="analytic"/></xsl:if>
        <xsl:call-template name="search"/>
        <!-- For future reference, what we *really* need to do here is:
           1.   change the svn:external to point to the Github version of Sebastian's XSLT
                    (see https://github.com/TEIC/Stylesheets
                     and http://www.leewillis.co.uk/including-git-repo-svn-external/ for guidance)
            2.  create a $googleAnalytics variable with the code we want (UA-43203560-1)
        -->
    </xsl:template>
    
    <xsl:template name="stdfooter">
        <xsl:param name="style" select="'plain'"/>
        <xsl:param name="file"/>
        <!-- overriding the TEI XSLT to add an EpiDoc specific footer -->
        <div class="stdfooter">
            <address>
                <p class="version">
                    <xsl:text>EpiDoc version: </xsl:text>
                <xsl:value-of select="//tei:seg[@type='version']"/></p>
                <p class="creationdate">
                <xsl:text>Date: </xsl:text>
                <xsl:value-of select="substring(string(current-date()),1,10)"/></p>
            </address>
        </div>
    </xsl:template>
    
    
	<xsl:template match="tei:back"/>
    
            <xsl:template name="upLink">
                <xsl:param name="up"/>
                <xsl:param name="title"/>
            </xsl:template>
	
	<xsl:template name="previousLink"/>
	
	<xsl:template name="nextLink"/>

    <xsl:template match="tei:cell">
        <xsl:variable name="cellname">
            <xsl:choose>
                <xsl:when test="parent::tei:row[tei:match(@rend,'thead')]">th</xsl:when>
                <xsl:when test="parent::tei:row[@role='label' and not(preceding::tei:row)]">th</xsl:when>
                <xsl:otherwise>td</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$cellname}">
            <xsl:for-each select="@*">
                <xsl:choose>
                    <xsl:when test="name(.) = 'width' or name(.) =
                        'border' or name(.) = 'cellspacing'
                        or name(.) = 'cellpadding'">
                        <xsl:copy-of select="."/>
                    </xsl:when>
                    <xsl:when test="name(.)='rend' and starts-with(.,'width:')">
                        <xsl:attribute name="width">
                            <xsl:value-of select="substring-after(.,'width:')"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.)='rend' and starts-with(.,'class:')">
                        <xsl:attribute name="class">
                            <xsl:value-of select="substring-after(.,'class:')"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.)='rend' and starts-with(.,'style=')">
                        <xsl:attribute name="style">
                            <xsl:value-of select="substring-after(.,'style=')"/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.)='rend'">
                        <xsl:attribute name="class">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.)='cols'">
                        <xsl:attribute name="colspan">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.)='rows'">
                        <xsl:attribute name="rowspan">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="name(.)='xml:lang'">
                        <xsl:attribute name="lang">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:when test="local-name(.)='align'">
                        <xsl:attribute name="align">
                            <xsl:value-of select="."/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            <xsl:choose>
                <xsl:when test="@align"/>
                <xsl:when test="not($cellAlign='left')">
                    <xsl:attribute name="style">
                        <xsl:text>text-align:</xsl:text>
                        <xsl:value-of select="$cellAlign"/>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@role and not (@rend)">
                <xsl:attribute name="class">
                    <xsl:value-of select="@role"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@xml:id">	   
                <xsl:call-template name="makeAnchor"/>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- overriding TEI Stylesheets to correct behaviour of "tag" element -->
    
    <xsl:template match="tei:tag">
        <span class="tag">
            <xsl:text>&lt;</xsl:text>
            <xsl:choose>
                <xsl:when test="@type='end'"><xsl:text>/</xsl:text></xsl:when>
                <xsl:when test="@type='pi'"><xsl:text>?</xsl:text></xsl:when>
                <xsl:when test="@type='comment'"><xsl:text>!--</xsl:text></xsl:when>
                <xsl:when test="@type='ms'"><xsl:text>[CDATA[</xsl:text></xsl:when>
            </xsl:choose>
            <xsl:apply-templates />
            <xsl:choose>
                <xsl:when test="@type='empty'"><xsl:text>/</xsl:text></xsl:when>
                <xsl:when test="@type='pi'"><xsl:text>?</xsl:text></xsl:when>
                <xsl:when test="@type='comment'"><xsl:text>--</xsl:text></xsl:when>
                <xsl:when test="@type='ms'"><xsl:text>]]</xsl:text></xsl:when>
            </xsl:choose>
            <xsl:text>&gt;</xsl:text>
        </span>
    </xsl:template>
    
</xsl:stylesheet>
