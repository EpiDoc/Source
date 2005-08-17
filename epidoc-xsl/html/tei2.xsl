<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <!-- epidoc-tei2 -->
   <!-- 2005-08-10: created by Tom Elliott -->
   <xsl:template match="tei:TEI.2">
      <xsl:element name="html">
         <xsl:call-template name="tei2prefix" />
         <xsl:apply-templates />
         <xsl:call-template name="tei2postfix" />
      </xsl:element>
   </xsl:template>
   <xsl:template name="tei2prefix" />
   <xsl:template name="tei2postfix" />
</xsl:stylesheet>
