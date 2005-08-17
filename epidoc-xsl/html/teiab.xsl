<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:template match="tei:ab">
      <xsl:element name="p">
         <!-- do not move next line: customization stub -->
         <xsl:call-template name="teiabprefix" />
         <xsl:attribute name="class">abstract</xsl:attribute>
         <xsl:call-template name="propagateattrs" />
         <xsl:apply-templates />
         <!-- do not move next line: customization stub -->
         <xsl:call-template name="teiabpostfix" />
      </xsl:element>
   </xsl:template>
   <xsl:template match="tei:ab" mode="epidoc-edition">
      <xsl:element name="div">
         <!-- do not move next line: customization stub -->
         <xsl:call-template name="teiabeditionprefix" />
         <xsl:attribute name="class">abstract</xsl:attribute>
         <xsl:call-template name="propagateattrs" />
         <xsl:apply-templates />
         <!-- do not move next line: customization stub -->
         <xsl:call-template name="teiabeditionpostfix" />
      </xsl:element>
   </xsl:template>
   <xsl:template name="teiabprefix" />
   <xsl:template name="teiabpostfix" />
   <xsl:template name="teiabeditionprefix" />
   <xsl:template name="teiabeditionpostfix" />
</xsl:stylesheet>
