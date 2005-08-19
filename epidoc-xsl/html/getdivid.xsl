<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="getdivid">
       <xsl:choose>
          <xsl:when test="@id">
             <xsl:choose>
                <xsl:when test="count(ancestor::*) = 0"><xsl:value-of select="@id"/></xsl:when>
                <xsl:otherwise>
                   <xsl:choose>
                      <xsl:when test="starts-with(@id, /*/@id)"><xsl:value-of select="@id"/></xsl:when>
                      <xsl:otherwise><xsl:value-of select="/*/@id"/>-<xsl:value-of select="@id"/></xsl:otherwise>
                   </xsl:choose>
                </xsl:otherwise>
             </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
             <xsl:choose>
                <xsl:when test="@type and count(//tei:div[@type=./@type]) = 1"><xsl:value-of select="/*/@id"/>-<xsl:value-of select="@type"/></xsl:when>
                <xsl:when test="@n and count(//tei:div[@n=./@n]) = 1"><xsl:value-of select="/*/@id"/>-<xsl:value-of select="@n"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="/*/@id"/>-div<xsl:value-of select="count(preceding::tei:div)+1"/></xsl:otherwise>
             </xsl:choose>
          </xsl:otherwise>
       </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
