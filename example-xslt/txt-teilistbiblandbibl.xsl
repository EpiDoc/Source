<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- Need to find unicode for bullets, indenting -->
  
  <xsl:template match="listBibl">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <xsl:template match="bibl">
    <xsl:text>&#xA;&#xD;</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>

</xsl:stylesheet>
