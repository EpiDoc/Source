<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:template match="tei:orig[contains(ancestor::tei:div/@type, 'edition') and not(../@expan)]">
      <xsl:element name="span">
          <xsl:choose>
              <xsl:when test="tei:mark">
                  <xsl:attribute name="class">original-characters-or-marks-suppressed</xsl:attribute>
                  <xsl:attribute name="title"><xsl:for-each select="* | text()"><xsl:choose><xsl:when test="name()='mark'"><xsl:value-of select="@type"/> mark</xsl:when><xsl:otherwise><xsl:value-of select="."/></xsl:otherwise></xsl:choose></xsl:for-each></xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:attribute name="class">original-characters-suppressed</xsl:attribute>
                  <xsl:attribute name="title"><xsl:value-of select="."/></xsl:attribute>
              </xsl:otherwise>
          </xsl:choose></xsl:element>
   </xsl:template>
    <xsl:template match="tei:orig[contains(ancestor::tei:div/@type, 'edition') and ../@expan]">
            
    </xsl:template>
</xsl:stylesheet>
