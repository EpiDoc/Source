<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template match="tei:list">
      <xsl:choose>
         <xsl:when test="@type = 'ordered'">
            <xsl:element name="ol">
               <xsl:call-template name="propagateattrs">
                   <xsl:with-param name="dolang">no</xsl:with-param>
               </xsl:call-template>
               <xsl:apply-templates />
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="ul">
               <xsl:call-template name="propagateattrs">
                   <xsl:with-param name="dolang">no</xsl:with-param>
               </xsl:call-template>
               <xsl:apply-templates />
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
