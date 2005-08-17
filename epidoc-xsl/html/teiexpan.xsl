<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:template match="tei:expan">
      <xsl:element name="span">
         <!-- do not move next line: customization stub -->
         <xsl:call-template name="teiexpanprefix" />
         <xsl:attribute name="class">expansion</xsl:attribute>
         <xsl:attribute name="title">
            <xsl:value-of select="." />
         </xsl:attribute>
         <xsl:apply-templates />
         <!-- do not move next line: customization stub -->
         <xsl:call-template name="teiexpanpostfix" />
      </xsl:element>
   </xsl:template>
   <xsl:template name="teiexpanprefix" />
   <xsl:template name="teiexpanpostfix" />
</xsl:stylesheet>
