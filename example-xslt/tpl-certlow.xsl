<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- Called by different elements -->
  
  <xsl:template name="cert-low">
    <xsl:if test="@cert='low'">
      <xsl:text>(?)</xsl:text>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>
