<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||||||||||||||  copy all existing elements ||||||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||||||||||||||||| copy all comments  ||||||||||||||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="//comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||||||||||     EXCEPTIONS      ||||||||||||||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="tei:seg">
    <xsl:choose>
      <xsl:when test="@type='line'">
        <xsl:element name="lb">
          <xsl:copy-of select="@n"/>
          <xsl:copy-of select="@facs"/>
          <xsl:if
            test="child::seg[@type='wordend'] or child::w[@part='F'] or preceding-sibling::seg[@type='line'][1]/w[@part='I']">
            <xsl:attribute name="type">
              <xsl:text>worddiv</xsl:text>
            </xsl:attribute>
          </xsl:if>
        </xsl:element>
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <xsl:copy-of select="@*"/>
          <xsl:apply-templates/>
        </xsl:copy>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
