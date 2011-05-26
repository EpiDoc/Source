<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- Imported templates can be found in teigap.xsl -->
  <xsl:import href="teigap.xsl"/>
  
  <xsl:template match="gap[@reason = 'lost']">
    <xsl:if test="@extent='unknown' and @reason='lost' and @unit='line' and $leiden-style = 'ddbdp'">
      <xsl:text>&#xA;&#xD;</xsl:text>
    </xsl:if>
    <xsl:apply-imports/>
  </xsl:template>
  
</xsl:stylesheet>
