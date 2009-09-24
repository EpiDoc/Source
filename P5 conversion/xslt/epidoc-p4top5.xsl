<?xml version="1.0"?>

<!-- |||||||||||||||||||||||||||||||||||||||||| -->
<!-- ||||  Gabriel BODARD 2008-11-20    |||||| -->
<!-- |||| w/contribution from TE,HC,EM |||||| -->
<!-- ||||          Last update 2009-07-17       |||||| -->
<!-- |||||||||||||||||||||||||||||||||||||||||| -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns="http://www.tei-c.org/ns/1.0" xmlns:epidoc="http://epidoc.sf.net/ns/EpiDoc/8.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="no"/>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||  copy all existing elements ||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of
        select="@*[not(local-name()=('id','lang','default','org','sample','part','full','cert','status','anchored','degree','type'))]"/>
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
      <xsl:if test="@type">
        <xsl:attribute name="type">
          <xsl:value-of select="translate(@type,' ','-')"/>
        </xsl:attribute>
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
      RNGSchema="http://epidoc.googlecode.com/files/exp-epidoc.rng" type="xml" </xsl:processing-instruction>
    <!--
      RNGSchema="file:/c:/tomcat/webapps/cocoon/epidoc-sf/P5%20conversion/schema/exp-epidoc.rng"   type="xml"
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
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="add">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*[not(local-name() = 'place')]"/>
      <xsl:attribute name="place">
        <xsl:choose>
          <xsl:when test="@place = 'supralinear'">
            <xsl:text>above</xsl:text>
          </xsl:when>
          <xsl:when test="@place = 'infralinear'">
            <xsl:text>below</xsl:text>
          </xsl:when>
          <xsl:when test="@place = 'verso'">
            <xsl:text>overleaf</xsl:text>
          </xsl:when>
          <xsl:when test="@place">
            <xsl:value-of select="@place"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>unspecified</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
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
          <xsl:attribute name="match">
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
      <xsl:apply-templates/>
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
    <xsl:if test="//handShift">
      <xsl:element name="handNotes">
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:if>
  </xsl:template>

  <xsl:template match="hand">
    <xsl:if test="//handShift[@new = current()/@id]">
      <xsl:element name="handNote">
        <xsl:copy-of select="@*[not(local-name()='id')]"/>
        <xsl:if test="@id">
          <xsl:attribute name="xml:id">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:if>
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
  
  <xsl:template match="lb[@type='worddiv']">
    <xsl:element name="lb">
      <xsl:copy-of select="@*[not(local-name() = 'type')]"/>
      <xsl:attribute name="type">
        <xsl:text>inWord</xsl:text>
      </xsl:attribute>
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

  <xsl:template match="publicationStmt">
    <xsl:element name="publicationStmt">
      <xsl:element name="authority">
        <xsl:text>NYU Digital Library Technology Services</xsl:text>
      </xsl:element>
      <xsl:element name="idno">
        <xsl:attribute name="type">
          <xsl:text>filename</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="ancestor::TEI.2/@id"/>
      </xsl:element>
      <xsl:element name="idno">
        <xsl:attribute name="type">
          <xsl:text>ddb-perseus-style</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="ancestor::TEI.2/@n"/>
      </xsl:element>
      <xsl:element name="idno">
        <xsl:attribute name="type">
          <xsl:text>ddb-hybrid</xsl:text>
        </xsl:attribute>
        <xsl:variable name="volanddoc">
          <xsl:value-of select="substring-after(ancestor::TEI.2/@n, ';')"/>
        </xsl:variable>
        <xsl:variable name="opt">
          <xsl:choose>
          <xsl:when test="contains(ancestor::TEI.2/@n, ';;')">
            <xsl:number value="0"/>
          </xsl:when>
            <xsl:otherwise>
              <xsl:number value="1"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:variable name="collen">
          <xsl:value-of select="string-length(ancestor::TEI.2/@id) - (string-length($volanddoc)+$opt)"
          />
        </xsl:variable>
        <xsl:variable name="collect">
          <xsl:value-of select="substring(ancestor::TEI.2/@id, 1, number($collen))"/>
        </xsl:variable>
        <xsl:value-of select="concat($collect,';',$volanddoc)"/>
      </xsl:element>
      <xsl:element name="availability">
        <xsl:apply-templates select="p"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="revisionDesc">
    <xsl:element name="{local-name()}">
      <xsl:element name="change">
        <xsl:attribute name="when">
          <xsl:text>2009-06-27</xsl:text>
        </xsl:attribute>
        <xsl:attribute name="who">
          <xsl:text>GB</xsl:text>
        </xsl:attribute>
        <xsl:text>Converted from TEI P4 (EpiDoc DTD v. 6) to P5 (EpiDoc RNG schema)</xsl:text>
      </xsl:element>
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

  <xsl:template match="seg">
    <xsl:choose>
      <xsl:when test="@cert='low'">
        <xsl:apply-templates/>
        <xsl:element name="certainty">
          <xsl:attribute name="match">
            <xsl:text>..</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="locus">
            <xsl:text>value</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{local-name()}">
          <xsl:copy-of select="@*[not(local-name() = ('cert','part'))]"/>
          <xsl:if test="@part != 'N'">
            <xsl:copy-of select="@part"/>
          </xsl:if>
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="space">
    <xsl:element name="{local-name()}">
      <xsl:choose>
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
    </xsl:element>
  </xsl:template>

  <xsl:template match="titleStmt/title">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*[not(local-name() = ('n','level'))]"/>
      <xsl:if test="string-length(@n) > 0">
        <xsl:copy-of select="@n"/>
      </xsl:if>
      <xsl:apply-templates/>
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
      <xsl:copy-of select="@*[not(local-name()=('targOrder','evaluate','to','from','href'))]"/>
      <xsl:if test="@type">
        <xsl:attribute name="type">
          <xsl:value-of select="translate(@type,' ','-')"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@href">
        <xsl:attribute name="target">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
