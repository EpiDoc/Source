<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template match="div[@type='bibliography']">
	  <xsl:variable name="divlevel"><xsl:value-of select="count(ancestor::div)"/></xsl:variable>
    <xsl:text>

</xsl:text>
    <xsl:call-template name="utilIndent"><xsl:with-param name="indentSpaces" select="($divlevel+2)*$tabWidth"/></xsl:call-template>
	  <xsl:element name="div">
	    <xsl:call-template name="outputID"/>
	    <xsl:attribute name="class">bibliography</xsl:attribute>
      <xsl:apply-templates select="node()[name()!='head']"/>
      <xsl:call-template name="utilIndent"><xsl:with-param name="indentSpaces" select="($divlevel+2)*$tabWidth"/></xsl:call-template>
	  </xsl:element>
    <xsl:text>
</xsl:text>
	</xsl:template>
</xsl:stylesheet>
