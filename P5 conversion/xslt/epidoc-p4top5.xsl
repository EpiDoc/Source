<?xml version="1.0"?>

<!-- ||||||||||||||||||||||||||||||||||||||||| -->
<!-- ||||  Gabriel BODARD 2008-11-20   |||||| -->
<!-- ||||        Last update 2004-04-02       |||||| -->
<!-- ||||||||||||||||||||||||||||||||||||||||| -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns="http://www.tei-c.org/ns/1.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||  copy all existing elements |||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="*">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name() = 'id')][not(local-name() = 'lang')]"/>
      <xsl:if test="@id">
        <xsl:attribute name="xml:id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@lang">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="@lang"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||||||||| copy all comments  |||||||||||||||| -->
  <!-- |||||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="//comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||     EXCEPTIONS      |||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="TEI.2">
    <xsl:element name="TEI">
      <xsl:copy-of select="@*[not(local-name() = 'id')][not(local-name() = 'lang')]"/>
      <xsl:attribute name="xml:id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:attribute name="xml:lang">
        <xsl:choose>
          <xsl:when test="@lang">
            <xsl:value-of select="@lang"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>en</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <!--      <xsl:attribute name="xmlns">
        <xsl:text>http://www.tei-c.org/ns/1.0</xsl:text>
      </xsl:attribute>-->
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="language">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name() = 'id')]"/>
      <xsl:attribute name="ident">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="persName|name|placeName|geogName|rs">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name() = 'reg')]"/>
      <xsl:if test="@reg">
        <xsl:attribute name="ref">
          <xsl:text>local#</xsl:text>
          <xsl:value-of select="@reg"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="xref">
    <xsl:element name="ref">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="revisionDesc">
    <xsl:copy>
      <xsl:for-each select="change">
        <xsl:copy>
          <xsl:attribute name="when">
            <xsl:value-of select="date"/>
          </xsl:attribute>
          <xsl:attribute name="who">
            <xsl:value-of select="respStmt/name"/>
          </xsl:attribute>
          <xsl:value-of select="item"/>
        </xsl:copy>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="gap">
    <xsl:copy>
      <xsl:copy-of select="@reason"/>
      <xsl:choose>
        <xsl:when test="@extent and @extentmax">
          <xsl:attribute name="atLeast">
            <xsl:value-of select="@extent"/>
          </xsl:attribute>
          <xsl:attribute name="atMost">
            <xsl:value-of select="@extentmax"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@extent != 'unknown'">
          <xsl:attribute name="quantity">
            <xsl:value-of select="@extent"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@extent='unknown'">
          <xsl:copy-of select="@extent"/>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="@unit">
        <xsl:copy-of select="@unit"/>
      </xsl:if>
      <xsl:if test="@precision='circa'">
        <xsl:attribute name="precision">
          <xsl:text>low</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@id">
        <xsl:attribute name="xml:id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@desc">
        <xsl:element name="desc">
          <xsl:value-of select="@desc"/>
        </xsl:element>
      </xsl:if>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="keywords">
    <xsl:copy>
      <xsl:attribute name="scheme">
        <xsl:text>DDbDP</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="handList">
    <xsl:element name="handNotes">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="hand">
    <xsl:element name="handNote">
      <xsl:copy-of select="@*[not(local-name()='id')]"/>
      <xsl:if test="@id">
        <xsl:attribute name="xml:id">
          <xsl:value-of select="@id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
