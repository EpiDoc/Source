<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <!-- div[@type = 'edition']" and div[starts-with(@type, 'textpart')] can be found in txt-teidivedition.xsl -->

  <xsl:template match="div">
    <xsl:if test="not(starts-with($leiden-style, 'edh'))">
      <xsl:text>&#xA;&#xD;</xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
