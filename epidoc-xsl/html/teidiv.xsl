<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:template match="tei:div">
      <xsl:element name="div">
         <xsl:call-template name="teidivprefix" />
         <xsl:call-template name="propagateattrs" />
         <xsl:if test="@type">
            <xsl:attribute name="class">
               <xsl:value-of select="@type" />
            </xsl:attribute>
         </xsl:if>
         <xsl:apply-templates />
         <xsl:call-template name="teidivpostfix" />
      </xsl:element>
   </xsl:template>
   <xsl:template name="teidivprefix" />
   <xsl:template name="teidivpostfix" />
</xsl:stylesheet>
