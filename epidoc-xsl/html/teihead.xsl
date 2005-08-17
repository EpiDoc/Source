<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="tei:head">
        <xsl:call-template name="teiheadprefix"/>
        
        <xsl:variable name="headlevel"><xsl:value-of select="count(ancestor::tei:div)+1"/></xsl:variable>
        <xsl:variable name="htag">
            <xsl:choose>
                <xsl:when test="$headlevel &lt; 7">h<xsl:value-of select="$headlevel"/></xsl:when>
                <xsl:otherwise>6</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:element name="{$htag}">
            <xsl:call-template name="propagateattrs"/>
            <xsl:apply-templates/>
        </xsl:element>
        
        <xsl:call-template name="teiheadpostfix"/>
    </xsl:template>
    <xsl:template match="tei:head" mode="epidoc-edition"><xsl:apply-templates select="."/></xsl:template>
    
    <xsl:template name="teiheadprefix"/>
    <xsl:template name="teiheadpostfix"/>
</xsl:stylesheet>
