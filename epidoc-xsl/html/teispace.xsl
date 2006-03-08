<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
    <xsl:template match="tei:space">
        <xsl:variable name="spaceid">
            <xsl:value-of select="@id" />
        </xsl:variable>
        <xsl:element name="span">
            <xsl:attribute name="class">space</xsl:attribute>
            <xsl:attribute name="title">vacat = blank space</xsl:attribute>
            (v.<xsl:if test="./@id and //tei:certainty[@target=$spaceid and @locus='#gi' and @degree='low']">?</xsl:if>
            <xsl:if test="@extent">
                <xsl:text> </xsl:text><xsl:value-of select="@extent"/>
                <xsl:if test="@unit != 'character'"><xsl:text> </xsl:text><xsl:value-of select="@unit"/></xsl:if>
                <xsl:if test="./@id and ./@extent and //tei:certainty[@target=$spaceid and @locus='extent' and @degree='low']">?</xsl:if> 
            </xsl:if>)</xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
