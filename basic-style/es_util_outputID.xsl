<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template name="outputID">
	  <xsl:attribute name="id">
	    <xsl:choose>
	      <xsl:when test="@id"><xsl:value-of select="@id"/></xsl:when>
	      <xsl:otherwise><xsl:value-of select="generate-id()"/></xsl:otherwise>
	    </xsl:choose>
	  </xsl:attribute>
	</xsl:template>
</xsl:stylesheet>
