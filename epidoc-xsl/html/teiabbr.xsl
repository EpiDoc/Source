<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- abbreviations inside an epidoc edition div -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="tei:abbr[contains(ancestor::tei:div/@type, 'edition')]">
        <xsl:choose>
            <xsl:when test="name(..)='expan'">
                <xsl:element name="span">
                    <xsl:attribute name="class">original-characters</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
            <xsl:when test="name(..)!='expan' and not(./@expan)">
                <xsl:element name="span">
                    <xsl:attribute name="class">epigraphic-abbreviation-not-understood</xsl:attribute>
                    <xsl:attribute name="title">
                        <xsl:value-of select="." />
                    </xsl:attribute><xsl:apply-templates />(- - -)</xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="span">
                    <xsl:attribute name="class">error</xsl:attribute>
                    <xsl:attribute name="title">untrapped abbreviation construct for an epidoc division in teiabbr.xsl</xsl:attribute><xsl:apply-templates/></xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- abbreviations not inside an epidoc edition div -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="tei:abbr[not(contains(ancestor::tei:div/@type, 'edition'))]">
        <xsl:element name="abbr">
            <xsl:attribute name="title"><xsl:value-of select="@expan"/></xsl:attribute><xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
