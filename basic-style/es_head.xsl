<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template match="head">
	  <xsl:variable name="headlevel"><xsl:value-of select="count(ancestor::div)"/></xsl:variable>
    <xsl:text>
</xsl:text>
    <xsl:call-template name="utilIndent"><xsl:with-param name="indentSpaces" select="($headlevel+2)*$tabWidth"/></xsl:call-template>

	  <xsl:choose>
	    <xsl:when test="$headlevel=1"><h2><xsl:apply-templates/></h2></xsl:when>
	    <xsl:when test="$headlevel=2"><h3><xsl:apply-templates/></h3></xsl:when>
	    <xsl:when test="$headlevel=3"><h4><xsl:apply-templates/></h4></xsl:when>
	    <xsl:otherwise><h5><xsl:apply-templates/></h5></xsl:otherwise>
	  </xsl:choose>
	</xsl:template>
</xsl:stylesheet>
