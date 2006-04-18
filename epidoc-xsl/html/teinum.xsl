<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="tei:num">
      <xsl:if test="ancestor-or-self::*[@lang][1][@lang='grc'] and @value &gt;= 1000 and not(@type='acrophonic')">
        <xsl:text>&#x0375;</xsl:text>
      </xsl:if>
      <xsl:apply-templates/>
      <xsl:if test="ancestor-or-self::*[@lang][1][@lang='grc'] and not(@value mod 1000 = 0) and not(@type='acrophonic')">
        <xsl:text>&#x00B4;</xsl:text>
      </xsl:if>
    </xsl:template>
</xsl:stylesheet>
