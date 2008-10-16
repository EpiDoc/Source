<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id: htm-teinote.xsl 1447 2008-08-07 12:57:55Z zau $ -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <!-- Template in teinote.xsl -->
  <xsl:import href="teinote.xsl"/>
  
  <xsl:template match="note">
    <xsl:choose>
      <xsl:when test="ancestor::p or ancestor::l or ancestor::ab">
        <xsl:choose>
          <xsl:when test="$edition-type='diplomatic' and ancestor::ab and @rend='italic'">
            <em>
              <xsl:apply-imports/>
            </em>
          </xsl:when>
          <xsl:otherwise>
        <xsl:apply-imports/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <p class="note">
          <xsl:apply-imports/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>
