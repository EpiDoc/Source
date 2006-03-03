<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:template match="tei:abbr/tei:orig">
      <xsl:element name="span">
         <!-- do not move next line: customization stub -->
         <xsl:call-template name="teiabbrorigprefix" />
         <xsl:attribute name="class">abbreviationmark</xsl:attribute>
         <xsl:attribute name="title">
            <xsl:value-of select="." />
         </xsl:attribute>
         <!-- do not move next line: customization stub -->
         <xsl:call-template name="teiabbrorigpostfix" />
      </xsl:element>
   </xsl:template>
   <xsl:template name="teiabbrorigprefix" />
   <xsl:template name="teiabbrorigpostfix"/>
</xsl:stylesheet>
