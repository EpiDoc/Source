<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="doubleParentheses">
  <xsl:choose>
    <xsl:when test=". = 'bs'"><c type="Claudian">bs</c></xsl:when>
    <xsl:when test=". = 'ps'"><c type="Claudian">ps</c></xsl:when>
    <xsl:when test=". = 'v'"><c type="Claudian">v</c></xsl:when>
    <xsl:when test=". = 'y'"><c type="Claudian">y</c></xsl:when>
    <xsl:when test="string-length(.) = 1"><hi rend="reversed"><xsl:apply-templates/></hi></xsl:when>
    <xsl:otherwise><xsl:element name="mark"><xsl:attribute name="type"><xsl:value-of select="."/></xsl:attribute></xsl:element></xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>
