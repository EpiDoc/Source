<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="text()">
    <xsl:choose>
      <xsl:when test="contains(.,'&#13;') or contains(.,'&#10;')">
        <xsl:variable name="content"><xsl:value-of select="translate(., '&#13;&#10;&#9;', '   ')"/></xsl:variable>
        <xsl:variable name="spaceFirst">
          <xsl:choose>
            <xsl:when test="substring($content, 1, 1)=' '">yes</xsl:when>
            <xsl:otherwise>no</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="spaceLast">
          <xsl:choose>
            <xsl:when test="substring($content, string-length($content), 1)=' '">yes</xsl:when>
            <xsl:otherwise>no</xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$spaceFirst='yes'"><xsl:text> </xsl:text></xsl:if><xsl:value-of select="normalize-space($content)"/><xsl:if test="$spaceLast='yes'"><xsl:text> </xsl:text></xsl:if> 
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
  </xsl:template> 
</xsl:stylesheet>
