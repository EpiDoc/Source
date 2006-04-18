<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xml="http://www.w3.org/XML/1998/namespace">

    <xsl:import href="dohtmlheadboilerplate.xsl"/>
    <xsl:import href="getdoctitle.xsl"/>
    <xsl:import href="writehtmldc.xsl"/>
    <xsl:import href="writehtmlmeta.xsl"/>
    <xsl:import href="sitemapteitext.xsl"/>
    <xsl:import href="dohtmlbodyboilerplate.xsl"/>
    <xsl:import href="getdivid.xsl"/>
    <xsl:import href="lowercase.xsl"/>
    <xsl:import href="doteiheadermetadata.xsl"/>
    <xsl:import href="dolangattr.xsl"/>
        <xsl:import href="sitemapteidiv.xsl"/>
    <xsl:import href="multipartpopdown.xsl"/>
    <xsl:param name="faviconpath">img/favicon.ico</xsl:param>
    <xsl:param name="standalonecss"></xsl:param>
    <xsl:param name="screencsspath">epidocscreen.css</xsl:param>
    <xsl:param name="printcsspath">epidocprint.css</xsl:param>
    <xsl:param name="htmlheaderdivid">htmlheader</xsl:param>
    <xsl:param name="htmlseparatordivid">htmlnavigation</xsl:param>
    <xsl:param name="htmlcontentdivid">htmlcontent</xsl:param> 
    <xsl:param name="sitemaptitleprefix">Table of Contents: </xsl:param>
    <xsl:template match="/tei:TEI.2">
        <xsl:element name="html">
            <xsl:call-template name="dohtmlheadboilerplate">
                <xsl:with-param name="doctitleprefix"><xsl:value-of select="$sitemaptitleprefix"/></xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates select="tei:text"/>
            
        </xsl:element>
    </xsl:template>
    

</xsl:stylesheet>
