<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template match="lb">
    <xsl:if test="@type='worddiv'">-</xsl:if>
    <xsl:text>
</xsl:text>
    <xsl:call-template name="utilIndent"><xsl:with-param name="indentSpaces" select="(count(ancestor::div|ab)+3)*$tabWidth"/></xsl:call-template>
    <xsl:if test="count(preceding::lb)>0"><xsl:text> / </xsl:text></xsl:if>
    <xsl:element name="span">
      <xsl:attribute name="id">
        <xsl:choose>
          <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
          <xsl:when test="@n">line<xsl:value-of select="@n"/></xsl:when>
          <xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element><xsl:choose>
      <xsl:when test="$lineInterval=0"></xsl:when>
      <xsl:when test="$lineInterval>1">
        <xsl:choose>
          <xsl:when test="(count(preceding::lb)+1) mod $lineInterval = 0"><span class="linenumber"><xsl:choose><xsl:when test="@n"><xsl:value-of select="@n"/></xsl:when><xsl:otherwise><xsl:value-of select="count(preceding::lb)+1"/></xsl:otherwise></xsl:choose></span></xsl:when>
          <xsl:otherwise><span class="linenumber"></span></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise><span class="linenumber"><xsl:choose><xsl:when test="@n"><xsl:value-of select="@n"/></xsl:when><xsl:otherwise><xsl:value-of select="count(preceding::lb)+1"/></xsl:otherwise></xsl:choose></span></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
