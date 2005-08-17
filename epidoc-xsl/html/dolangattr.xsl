<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template name="dolangattr">
      <xsl:if test="./@lang">
         <xsl:attribute name="lang"><xsl:value-of  select="./@lang"/></xsl:attribute>
         <xsl:attribute name="lang" namespace="http://www.w3.org/XML/1998/namespace"><xsl:value-of select="./@lang"/></xsl:attribute>
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>
