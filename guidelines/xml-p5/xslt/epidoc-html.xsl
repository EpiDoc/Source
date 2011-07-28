<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:s="http://www.ascc.net/xml/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:t="http://www.thaiopensource.com/ns/annotations"
    xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
    xmlns:rng="http://relaxng.org/ns/structure/1.0" exclude-result-prefixes="tei t a rng s teix"
    version="2.0">

    <xsl:import href="http://www.tei-c.org/release/xml/tei/stylesheet/odds2/odd2html.xsl"/>
    <!-- <xsl:import href="/Applications/oxygen/frameworks/tei/xml/tei/stylesheet/odds2/odd2html.xsl"/> -->
    <!-- <xsl:import href="../../example-p5-xslt/htm-imports.xsl"/> -->
    <xsl:import href="render-epidoc.xsl"/>

    <xsl:output encoding="utf-8" method="xml" doctype-public="-//W3C//DTD XHTML 1.1//EN"/>
    <xsl:param name="STDOUT">false</xsl:param>
    <xsl:param name="splitLevel">0</xsl:param>
    <xsl:param name="autoToc">false</xsl:param>
    <xsl:param name="cssFile">css/epidoc.css</xsl:param>
    <xsl:param name="cssSecondaryFile">../schema/epidoc-odd.css</xsl:param>
    <xsl:param name="TEIC">true</xsl:param>
    <xsl:param name="forceWrap">false</xsl:param>

    <xsl:template name="egXMLEndHook">
        <xsl:call-template name="render-epidoc"/>
        <xsl:if test="@corresp">
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
                        <xsl:value-of select="number(substring($filename,1,2))"/>
                        <xsl:text>.</xsl:text>
                        <xsl:value-of select="number(substring($filename,3,4))"/>
                    </xsl:when>
                    <xsl:when test="starts-with(@corresp, 'http://insaph.kcl.ac.uk/ala2004/')">
                        <xsl:text>ALA: </xsl:text>
                        <xsl:variable name="filename">
                            <xsl:value-of
                                select="substring-before(substring-after(@corresp,'http://insaph.kcl.ac.uk/ala2004/inscription/eAla'),'.html')"
                            />
                        </xsl:variable>
                        <xsl:value-of select="number($filename)"/>
                    </xsl:when>
                    <xsl:when test="starts-with(@corresp, 'http://irt.kcl.ac.uk/')">
                        <xsl:text>IRT: </xsl:text>
                        <xsl:variable name="filename">
                            <xsl:value-of
                                select="substring-before(substring-after(@corresp,'http://irt.kcl.ac.uk/irt2009/IRT'),'.html')"
                            />
                        </xsl:variable>
                        <xsl:value-of select="number(translate($filename,'abcdefghi',''))"/>
                        <xsl:value-of select="translate($filename,'0123456789','')"/>
                    </xsl:when>
                    <xsl:when test="starts-with(@corresp, 'http://papyri.info/ddbdp/')">
                        <xsl:text>DDbDP: </xsl:text>
                        <xsl:variable name="filename">
                            <xsl:value-of
                                select="substring-before(substring-after(@corresp,'http://papyri.info/ddbdp/'),'/')"
                            />
                        </xsl:variable>
                        <xsl:value-of select="translate($filename,';','.')"/>
                    </xsl:when>
                    <xsl:when test="starts-with(@corresp,'#') and //tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]">
                        <xsl:for-each select="//tei:bibl[@xml:id = current()/@corresp]/tei:author">
                            <xsl:value-of select="."/>
                            <xsl:if test="following-sibling::tei:author">
                                <xsl:text>/</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </xsl:element>
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

    <xsl:template match="tei:cit/tei:bibl">
            <xsl:if test="starts-with(@corresp,'#') and //tei:bibl[@xml:id = substring-after(current()/@corresp, '#')]">
                <span class="ref">
                    <xsl:for-each select="//tei:bibl[@xml:id = current()/@corresp]/tei:author">
                        <xsl:value-of select="."/>
                        <xsl:if test="following-sibling::tei:author">
                            <xsl:text>/</xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                </span>
            </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>
