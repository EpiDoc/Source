<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="ab">
	  <xsl:variable name="plevel"><xsl:value-of select="count(ancestor::div)"/></xsl:variable>
    <xsl:text>
</xsl:text>
    <xsl:call-template name="utilIndent"><xsl:with-param name="indentSpaces" select="($plevel+2)*$tabWidth"/></xsl:call-template>
    <p class="ab"><xsl:apply-templates/></p>
    <xsl:text>
</xsl:text>
  </xsl:template>
</xsl:stylesheet>

