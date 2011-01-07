<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:t="http://www.tei-c.org/ns/1.0" version="2.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||  copy all existing elements ||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="t:*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||||||||| copy comments & processing instructions |||||||||||||||| -->
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="//comment() | //processing-instruction()">
    <xsl:copy>
      <xsl:value-of select="."/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||    EXCEPTIONS     |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="t:origin/t:p">
    <xsl:element name="origPlace">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="t:encodingDesc">
    <xsl:element name="{local-name()}">
    <xsl:apply-templates/>
      <xsl:element name="classDecl">
      <xsl:element name="taxonomy">
        <xsl:element name="category">
          <xsl:attribute name="xml:id">
            <xsl:text>photograph</xsl:text>
          </xsl:attribute>
          <xsl:element name="catDesc">
          <xsl:text>Digital or digitized photographs</xsl:text>
          </xsl:element>
        </xsl:element>
        <xsl:element name="category">
          <xsl:attribute name="xml:id">
            <xsl:text>representation</xsl:text>
          </xsl:attribute>
          <xsl:element name="catDesc">
          <xsl:text>Digitized other representations</xsl:text>
            </xsl:element>
        </xsl:element>
      </xsl:element>
      </xsl:element>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="t:teiHeader">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
    <xsl:element name="facsimile">
      <xsl:for-each select="//t:div[@type='figure']//t:figure">
        <xsl:element name="graphic">
          <xsl:attribute name="url">
            <xsl:value-of select="t:graphic/@url"/>
          </xsl:attribute>
          <xsl:element name="desc">
            <xsl:value-of select="t:head"/>
          </xsl:element>
        </xsl:element>
      </xsl:for-each>
      <xsl:for-each select="//t:div[@type='figure']/t:p/text()">
        <xsl:comment>
            <xsl:value-of select="."/>
          </xsl:comment>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="t:div[@type='figure']"/>

</xsl:stylesheet>
