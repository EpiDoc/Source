<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="ptr">
    <xsl:variable name="targetValue"><xsl:value-of select="@target"/></xsl:variable>
    <xsl:variable name="nodeName"><xsl:value-of select="name(//node()[@id = $targetValue])"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="$nodeName = 'bibl' or $nodeName = 'biblStruct' or $nodeName = 'biblFull'">
        <xsl:element name="a">
          <xsl:attribute name="href">#<xsl:value-of select="@target"/></xsl:attribute>
          <xsl:apply-templates select="//node()[@id = $targetValue]" mode="biblPtr"/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="a">
          <xsl:attribute name="href">#<xsl:value-of select="@target"/></xsl:attribute>
          <xsl:value-of select="@target"/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="node()" mode="biblPtr">
   <xsl:choose>
      <xsl:when test="descendant::title">
        <xsl:value-of select="descendant::title"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="descendant::idno[@type='URL']"/></xsl:otherwise>
   </xsl:choose>  
  </xsl:template>
</xsl:stylesheet> 
