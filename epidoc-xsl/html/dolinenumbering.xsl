<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template name="dolinenumbering">
      <xsl:variable name="language" select="ancestor::*[@lang][last()]/@lang"></xsl:variable>
      <xsl:choose>
         <xsl:when test="@n">
            <xsl:if test="@n mod $linenumberinterval = 0">
               <xsl:element name="span">
                  <xsl:attribute name="class">linenumber</xsl:attribute>
                  <xsl:attribute name="lang"><xsl:value-of select="$language"/></xsl:attribute>
                  <xsl:attribute name="lang" namespace="http://www.w3.org/XML/1998/namespace"><xsl:value-of select="$language"/></xsl:attribute>
                  <xsl:value-of select="@n" />
               </xsl:element>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="count(preceding::lb) mod $linenumberinterval = 0">
               <xsl:element name="span">
                  <xsl:attribute name="class">linenumber</xsl:attribute>
                  <xsl:attribute name="lang"><xsl:value-of select="$language"/></xsl:attribute>
                  <xsl:attribute name="lang" namespace="http://www.w3.org/XML/1998/namespace"><xsl:value-of select="$language"/></xsl:attribute>
                  <xsl:value-of select="count(preceding::lb)" />
               </xsl:element>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
