<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
   <xsl:template name="getid">
      <xsl:choose>
         <xsl:when test="name(.) = 'div'"><xsl:call-template name="getdivid"/></xsl:when>
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="@id"><xsl:value-of select="@id" /></xsl:when>
               <xsl:when test="name(.)='head' and ../@id"><xsl:value-of select="../@id" />-head</xsl:when>
               <xsl:when test="name(.)='lb' and ./@n">line-<xsl:value-of select="./@n" /></xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="tagname" select="name(.)" /><xsl:value-of select="name(.)" />-<xsl:value-of select="count(preceding::*[name() = $tagname]) + 1" /></xsl:otherwise>
            </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
