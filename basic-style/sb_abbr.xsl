<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="abbr">
    <xsl:apply-templates /><xsl:text>.</xsl:text>
  </xsl:template>
</xsl:stylesheet>
