<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="figure">
    <xsl:element name="div">
      <xsl:attribute name="class">imagebox</xsl:attribute>
      <xsl:apply-templates select="head" mode="figure"/>
      <xsl:apply-templates select="linkGrp" mode="figure"/>
      <xsl:apply-templates select="figDesc" mode="figure"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="head" mode="figure">
    <span class="imagecaption"><xsl:apply-templates /></span>
  </xsl:template>
  
  <xsl:template match="linkGrp" mode="figure">
    <xsl:element name="div">
      <xsl:attribute name="class">image</xsl:attribute>
      <xsl:element name="a">
        <xsl:attribute name="href"><xsl:value-of select="link[@type='image' and @rend='link']/@targets"/></xsl:attribute>
        <xsl:element name="img">
          <xsl:attribute name="src"><xsl:value-of select="link[@type='image' and @rend='embed']/@targets"/></xsl:attribute>
        </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="figDesc" mode="figure">
    <span class="imagedescription"><xsl:apply-templates /></span>
  </xsl:template>
  
</xsl:stylesheet>

