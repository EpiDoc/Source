<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template match="div[@type='edition']">
	  <xsl:variable name="divlevel"><xsl:value-of select="count(ancestor::div)"/></xsl:variable>
    <xsl:text>

</xsl:text>
    <xsl:call-template name="utilIndent"><xsl:with-param name="indentSpaces" select="($divlevel+2)*$tabWidth"/></xsl:call-template>
	  <xsl:element name="div">
	    <xsl:call-template name="outputID"/>
      <xsl:call-template name="outputLangAttributes"/>
	    <xsl:attribute name="class">edition</xsl:attribute>
	    <xsl:apply-templates/>
      <xsl:if test="descendant::sic[@corr] | descendant::corr[@sic]">
        <div>
            <xsl:call-template name="enumerateCorrections"/>
        </div>
      </xsl:if>
      <xsl:if test="descendant::app">
        <div>
          <xsl:variable name="headlevel"><xsl:value-of select="count(ancestor::div)+2"/></xsl:variable>
          <xsl:variable name="heading">Apparatus:</xsl:variable>
          <xsl:choose>
            <xsl:when test="$headlevel=1"><h2><xsl:value-of select="$heading"/></h2></xsl:when>
            <xsl:when test="$headlevel=2"><h3><xsl:value-of select="$heading"/></h3></xsl:when>
            <xsl:when test="$headlevel=3"><h4><xsl:value-of select="$heading"/></h4></xsl:when>
            <xsl:otherwise><h5><xsl:value-of select="$heading"/></h5></xsl:otherwise>
          </xsl:choose>
          <ul>
            <xsl:apply-templates select="descendant::app" mode="apparatus"/>
          </ul>
        </div>
      </xsl:if>
      <xsl:call-template name="utilIndent"><xsl:with-param name="indentSpaces" select="($divlevel+2)*$tabWidth"/></xsl:call-template>
	  </xsl:element>
    <xsl:text>
</xsl:text>

	</xsl:template>
</xsl:stylesheet>
