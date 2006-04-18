<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <!-- epidoc-teitext -->
   <!-- 2005-08-10: created by Tom Elliott -->
   <xsl:template match="tei:text">
      <xsl:call-template name="dohtmlbodyboilerplate">
          <xsl:with-param name="doctitleprefix"><xsl:value-of select="$sitemaptitleprefix"/></xsl:with-param>
          <xsl:with-param name="includenav">no</xsl:with-param>
          <xsl:with-param name="processteiheader">no</xsl:with-param>
      </xsl:call-template>
   </xsl:template>
</xsl:stylesheet>
