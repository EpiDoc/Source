<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- Template in teinote.xsl -->
  <xsl:import href="teinote.xsl"/>

  <xsl:template match="note">
    <xsl:choose>
      <xsl:when test="ancestor::p or ancestor::l or ancestor::ab">
        <xsl:apply-imports/>
      </xsl:when>
      <xsl:otherwise>
        <p class="note">
          <xsl:apply-imports/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
