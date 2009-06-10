<?xml version="1.0"?>

<!-- ||||||||||||||||||||||||||||||||||||||||| -->
<!-- ||||  Gabriel BODARD 2008-11-20    |||||| -->
<!-- |||| w/contribution from TE,HC,EM |||||| -->
<!-- ||||           Last update 2004-05-26        |||||| -->
<!-- ||||||||||||||||||||||||||||||||||||||||| -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns="http://www.tei-c.org/ns/1.0" xmlns:epidoc="http://epidoc.sf.net/ns/EpiDoc/8.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||  copy all existing elements ||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of
        select="@*[not(local-name()=('id','lang','default','org','sample','part','full','cert','status','anchored','degree'))]"/>
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
      <xsl:if test="@cert='low'">
        <xsl:copy-of select="@cert"/>
      </xsl:if>
      <xsl:if test="number(@degree)">
        <xsl:copy-of select="@degree"/>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
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
    <xsl:processing-instruction name="oxygen ">
      RNGSchema="file:/c:/tomcat/webapps/cocoon/epidoc-sf/P5%20conversion/schema/exp-epidoc.rng"
      type="xml" </xsl:processing-instruction>
    <!--
       RNGSchema="http://epidoc.googlecode.com/files/exp-epidoc.rng" type="xml"
      -->
    <xsl:element name="TEI">
      <xsl:copy-of select="@*[not(local-name() = ('id','lang'))]"/>
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

  <xsl:template match="certainty">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*[not(local-name() = ('locus','target','degree'))]"/>
      <xsl:attribute name="target">
        <xsl:text>#</xsl:text>
        <xsl:value-of select="@target"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@locus = '#gi'">
          <xsl:attribute name="locus">
            <xsl:text>name</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="pattern">
            <xsl:text>@</xsl:text>
            <xsl:value-of select="@locus"/>
          </xsl:attribute>
          <xsl:attribute name="locus">
            <xsl:text>value</xsl:text>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>

    </xsl:element>
  </xsl:template>

  <xsl:template match="date">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*[not(local-name()=('precision','exact','cert'))]"/>
      <xsl:if test="@cert='low'">
        <xsl:copy-of select="@cert"/>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="@exact='none'">
          <xsl:attribute name="precision">
            <xsl:text>low</xsl:text>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="@precision='circa'">
          <xsl:attribute name="precision">
            <xsl:text>low</xsl:text>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:if test="@exact=('notAfter','notBefore')">
        <xsl:attribute name="xml:id">
          <xsl:value-of select="generate-id(.)"/>
        </xsl:attribute>
      </xsl:if>
    </xsl:element>
    <xsl:if test="@exact=('notAfter','notBefore')">
      <xsl:element name="precision">
        <xsl:attribute name="target">
          <xsl:text>#</xsl:text>
          <xsl:value-of select="generate-id(.)"/>
        </xsl:attribute>
        <xsl:attribute name="pattern">
          <xsl:choose>
            <xsl:when test="@exact='notBefore'">
              <xsl:text>@notAfter</xsl:text>
            </xsl:when>
            <xsl:when test="@exact='notAfter'">
              <xsl:text>@notBefore</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="gap">
    <xsl:element name="{local-name()}">
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
        <xsl:when test="number(@extent)">
          <xsl:attribute name="quantity">
            <xsl:value-of select="@extent"/>
          </xsl:attribute>
        </xsl:when>
        <xsl:when test="not(number(@extent))">
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
    </xsl:element>
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

  <xsl:template match="keywords">
    <xsl:element name="{local-name()}">
      <xsl:attribute name="scheme">
        <xsl:text>DDbDP</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="language">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*[not(local-name() = 'id')]"/>
      <xsl:attribute name="ident">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="measure">
    <xsl:choose>
      <xsl:when test="@dim=('height','width','depth')">
        <xsl:element name="{@dim}">
          <xsl:copy-of select="@*[not(local-name()=('type','dim','precision'))]"/>
          <xsl:if test="@precision='circa'">
            <xsl:attribute name="precision">
              <xsl:text>low</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="dim">
          <xsl:copy-of select="@*[not(local-name()=('type','dim','precision'))]"/>
          <xsl:attribute name="type">
            <xsl:value-of select="@dim"/>
          </xsl:attribute>
          <xsl:if test="@precision='circa'">
            <xsl:attribute name="precision">
              <xsl:text>low</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!--  <xsl:template match="num[contains(@value, '/')]">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
       <xsl:attribute name="valueType">
         <xsl:text>fraction</xsl:text>
       </xsl:attribute>
    </xsl:element>
  </xsl:template>-->

  <xsl:template match="persName|name|placeName|geogName">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*[not(local-name() = ('reg','full','cert'))]"/>
      <xsl:if test="@cert='low'">
        <xsl:copy-of select="@cert"/>
      </xsl:if>
      <xsl:if test="@reg">
        <xsl:attribute name="nymRef">
          <xsl:value-of select="local-name()"/>
          <xsl:text>AL#</xsl:text>
          <xsl:value-of select="@reg"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="rs">
    <xsl:choose>
      <xsl:when test="@type='dimensions'">
        <xsl:element name="dimensions">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{local-name()}">
          <xsl:copy-of select="@*[not(local-name() = ('reg','full','cert'))]"/>
          <xsl:if test="@cert='low'">
            <xsl:copy-of select="@cert"/>
          </xsl:if>
          <xsl:if test="@reg">
            <xsl:attribute name="ref">
              <xsl:value-of select="@type"/>
              <xsl:text>AL#</xsl:text>
              <xsl:value-of select="@reg"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="revisionDesc">
    <xsl:element name="{local-name()}">
      <xsl:for-each select="change">
        <xsl:element name="{local-name()}">
          <xsl:attribute name="when">
            <xsl:value-of select="date"/>
          </xsl:attribute>
          <xsl:attribute name="who">
            <xsl:value-of select="respStmt/name"/>
          </xsl:attribute>
          <xsl:value-of select="item"/>
        </xsl:element>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  <xsl:template match="unclear">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xptr">
    <xsl:element name="ptr">
      <xsl:copy-of select="@*[not(local-name()=('targOrder','evaluate','to','from'))]"/>
      <xsl:if test="@type">
        <xsl:attribute name="type">
          <xsl:value-of select="translate(@type,' ','-')"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@from">
        <xsl:attribute name="target">
          <xsl:value-of select="@from"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="xref">
    <xsl:element name="ref">
      <xsl:copy-of select="@*[not(local-name()=('targOrder','evaluate','to','from'))]"/>
      <xsl:if test="@type">
        <xsl:attribute name="type">
          <xsl:value-of select="translate(@type,' ','-')"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
