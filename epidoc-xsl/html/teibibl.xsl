<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template match="tei:bibl">
      <xsl:choose>
         <xsl:when test="name(..) = 'listBibl'">
            <xsl:element name="li">
               <xsl:call-template name="propagateattrs"/>
               <xsl:apply-templates />
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="span">
               <xsl:call-template name="propagateattrs"/>
               <xsl:attribute name="class">bibliographiccitation</xsl:attribute>
               <xsl:apply-templates />
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
