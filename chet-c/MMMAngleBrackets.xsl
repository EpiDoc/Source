<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="angleBrackets">
  <xsl:choose>
    <xsl:when test="hyphen">
      <xsl:element name="gap">
        <xsl:attribute name="reason">omitted</xsl:attribute>
        <xsl:attribute name="extent"><xsl:value-of select="count(hyphen)"/></xsl:attribute>
        <xsl:attribute name="unit">character</xsl:attribute>
      </xsl:element>
    </xsl:when>
    <xsl:when test="contains(text(), '=')">
      <xsl:element name="sic">
        <xsl:attribute name="corr"><xsl:value-of select="normalize-space(substring-before(., '='))"/></xsl:attribute>
        <xsl:value-of select="normalize-space(substring-after(., '='))"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:element name="sic">
        <xsl:attribute name="corr"><xsl:value-of select="."/></xsl:attribute>
      </xsl:element>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>
