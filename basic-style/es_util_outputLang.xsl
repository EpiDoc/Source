<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template name="outputLangAttributes">
    <xsl:variable name="myLang"><xsl:call-template name="outputLang"/></xsl:variable>
	  <xsl:attribute name="lang"><xsl:value-of select="$myLang"/></xsl:attribute>
    <xsl:attribute name="class"><xsl:value-of select="$myLang"/></xsl:attribute>
	</xsl:template>
  <xsl:template name="outputLang">
    <xsl:variable name="nodeLang"><xsl:value-of select="ancestor-or-self::*[@lang][1]/attribute::lang"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($nodeLang)=0"><xsl:value-of select="//TEI.2/@lang"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="$nodeLang"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
