<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="app">
    <xsl:apply-templates select="lem" mode="inline"/>
  </xsl:template>
  
  <xsl:template match="lem" mode="inline"><xsl:apply-templates/></xsl:template>
  
  <xsl:template match="app" mode="apparatus">
    <li>
      <xsl:element name="a">
        <xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
        <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
        <xsl:text> </xsl:text>
      </xsl:element><span class="linenumber">
      <xsl:for-each select="ancestor::div[@type!='edition']"><xsl:value-of select="@n"/>.</xsl:for-each>
      <xsl:value-of select="preceding::lb[1]/@n"/></span><xsl:text> </xsl:text>
      <xsl:apply-templates select="lem" mode="apparatus"/><xsl:text> : </xsl:text>
      <xsl:for-each select="rdg"><xsl:apply-templates select="." mode="apparatus"/><xsl:if test="following-sibling::rdg"><xsl:text> : </xsl:text></xsl:if></xsl:for-each>
    </li>
  </xsl:template>
  <xsl:template match="lem" mode="apparatus">
    <xsl:variable name="respID"><xsl:value-of select="@resp"/></xsl:variable>
    <xsl:variable name="respType"><xsl:value-of select="name(/descendant::*[@id=$respID])"/></xsl:variable>
    <span class="applem"><xsl:apply-templates/></span>
    <xsl:text> (</xsl:text><xsl:choose>
      <xsl:when test="$respType = 'respStmt'"><xsl:value-of select="/descendant::*[@id=$respID]/name"/></xsl:when>
      <xsl:when test="$respType = 'bibl' or $respType = 'biblStruct' or $respType = 'biblFull'"><xsl:value-of select="/descendant::*[@id=$respID]/descendant[name | editor | author][1]"/></xsl:when>
      <xsl:otherwise><xsl:apply-templates select="//*[@id=$respID]"/></xsl:otherwise>
    </xsl:choose><xsl:text>)</xsl:text>
  </xsl:template>
  <xsl:template match="rdg" mode="apparatus">
    <xsl:variable name="respID"><xsl:value-of select="@resp"/></xsl:variable>
    <xsl:variable name="respType"><xsl:value-of select="name(/descendant::*[@id=$respID])"/></xsl:variable>
    <xsl:apply-templates/>
    <xsl:text> (</xsl:text><xsl:choose>
      <xsl:when test="$respType = 'respStmt'"><xsl:value-of select="/descendant::*[@id=$respID]/name"/></xsl:when>
      <xsl:when test="$respType = 'bibl' or $respType = 'biblStruct' or $respType = 'biblFull'"><xsl:value-of select="/descendant::*[@id=$respID]/descendant::*[name | editor | author]"/></xsl:when>
      <xsl:otherwise><xsl:apply-templates select="//*[@id=$respID]"/></xsl:otherwise>
    </xsl:choose><xsl:text>)</xsl:text>
  </xsl:template>
  <xsl:template match="note" mode="apparatus">
    
  </xsl:template>

</xsl:stylesheet>
