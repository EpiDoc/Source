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
          <xsl:when test="contains(@href, '.xml')">
              <xsl:element name="a">
                  <xsl:attribute name="class">xref</xsl:attribute>
                  <xsl:attribute name="href"><xsl:value-of select="substring-before(@href, '.xml')"/>.html</xsl:attribute>
                  <xsl:call-template name="propagateattrs"
                      /><xsl:apply-templates/></xsl:element>
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
               <xsl:element name="a">
                  <xsl:attribute name="class">xref</xsl:attribute>
                  <xsl:variable name="targeturl">
                     <xsl:choose>
                        <xsl:when test="contains(@doc, '/')"><xsl:value-of select="@doc"/></xsl:when>
                        <xsl:when test="contains(@doc, '.xml')"><xsl:value-of select="@doc"/></xsl:when>
                        <xsl:when test="contains(@doc, '.html')"><xsl:value-of select="@doc"/></xsl:when>
                        <xsl:when test="contains(@doc, '.jpg')"><xsl:value-of select="@doc"/></xsl:when>
                        <xsl:when test="contains(@doc, '.svg')"><xsl:value-of select="@doc"/></xsl:when>
                        <xsl:when test="contains(@doc, '.gif')"><xsl:value-of select="@doc"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="@doc"/>.html</xsl:otherwise>
                     </xsl:choose><xsl:if test="@from">#<xsl:value-of select="substring-before(substring-after(@from, 'id('), ')')"/></xsl:if></xsl:variable>
                  <xsl:attribute name="href"><xsl:value-of select="$targeturl"/></xsl:attribute>
                  <xsl:call-template name="propagateattrs"
                     /><xsl:apply-templates 
                        /></xsl:element>
         </xsl:otherwise>
      </xsl:choose>
      </xsl:template>
</xsl:stylesheet>
