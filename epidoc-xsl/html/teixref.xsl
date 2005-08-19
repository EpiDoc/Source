<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template match="tei:xref">
      <xsl:choose>
         <xsl:when test="@type='include'">
            <xsl:element name="a">
               <xsl:attribute name="class">xref</xsl:attribute>
               <xsl:attribute name="href"><xsl:value-of select="substring-before(@href, '.xml')"/>.html</xsl:attribute>
               <xsl:call-template name="propagateattrs"
                  /><xsl:choose><xsl:when test="string-length(text()) != 0"><xsl:apply-templates/></xsl:when><xsl:otherwise><xsl:value-of select="@href"/></xsl:otherwise></xsl:choose></xsl:element>
         </xsl:when>
         <xsl:when test="contains(@href, '.xml#')">
            <xsl:element name="a">
               <xsl:attribute name="class">xref</xsl:attribute>
               <xsl:attribute name="href"><xsl:value-of select="substring-before(@href, '.xml#')"/>.html#<xsl:value-of select="substring-after(@href, '#')"/></xsl:attribute>
               <xsl:call-template name="propagateattrs"
                  /><xsl:apply-templates 
                     /></xsl:element>

         </xsl:when>
         <xsl:when test="@href">
            <xsl:element name="a">
               <xsl:attribute name="class">xref</xsl:attribute>
               <xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
               <xsl:call-template name="propagateattrs"
                  /><xsl:apply-templates 
                     /></xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:comment>teixref.xsl only handles the epidoc-specific href attribute on xref; extended pointers and other uses not currently handled</xsl:comment>
         </xsl:otherwise>
      </xsl:choose>
      </xsl:template>
</xsl:stylesheet>
