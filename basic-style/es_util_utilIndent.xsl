<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:template name="utilIndent">
  <xsl:param name="indentSpaces"/>
  <xsl:if test="$indentSpaces > 0"><xsl:text> </xsl:text><xsl:call-template name="utilIndent"><xsl:with-param name="indentSpaces" select="$indentSpaces -1"/></xsl:call-template></xsl:if>
</xsl:template>
</xsl:stylesheet>
