<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
   <!-- in EpiDoc orig within expan or abbr is omitted from rendered version-->
   <xsl:template match="tei:orig[contains(ancestor::tei:div/@type, 'edition') and ancestor::tei:expan]">
    </xsl:template>
    
    <!-- in EpiDoc, orig with [@n='unresolved'] means unresolved -->
    <xsl:template match="tei:orig[contains(@n, 'unresolved')]">
       <xsl:element name="span">
          <xsl:call-template name="propagateattrs"/>
          <xsl:attribute name="class">unintelligible</xsl:attribute>
          <xsl:choose>
             <xsl:when test="ancestor-or-self::*[@lang][1]/@lang='lat'">
               <xsl:value-of select="translate(text(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
             </xsl:when>
             <xsl:when test="ancestor-or-self::*[@lang][1]/@lang='grc'">
               <span style="text-transform: uppercase ;"><xsl:apply-templates/></span>
             </xsl:when>
             <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
          </xsl:choose>
       </xsl:element>
    </xsl:template>
   
</xsl:stylesheet>
