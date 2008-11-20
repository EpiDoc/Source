<?xml version="1.0"?>

<!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
<!-- ||||   XSLT Stylesheet to copy all content in DLV Testpages  |||||| -->
<!-- ||||  Gabriel BODARD 2004-03-23 :: with help from PS & JB    |||||| -->
<!-- |||||                Last update 2004-04-02                 ||||||| -->
<!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns="http://www.tei-c.org/ns/1.0"
      >

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||||||||||||||||||  output as XML  ||||||||||||||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:output 
        method="xml" 
        version="1.0" 
        encoding="UTF-8" 
        indent="no" 
      />

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||||||||||  copy all existing elements |||||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

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

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- |||||||||||||||||||||| copy all comments  ||||||||||||||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="//comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>

  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->
  <!-- ||||||||||||||||||||||          exceptions           ||||||||||||||||||||||||| -->
  <!-- ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| -->

  <xsl:template match="TEI.2">
    <xsl:element name="TEI">
      <xsl:copy-of select="@*[not(local-name() = 'id')][not(local-name() = 'lang')]"/>
      <xsl:attribute name="xml:id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
      <xsl:attribute name="xml:lang">
        <xsl:value-of select="@lang"/>
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

  <xsl:template match="xref">
    <xsl:element name="ref">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="revisionDesc">
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
  </xsl:template>

    <xsl:template match="gap">
      <xsl:copy>
        <xsl:copy-of select="@*[not(local-name = 'dim')][not(local-name = 'desc')]"/>
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
          <xsl:text>EAGLE</xsl:text>
        </xsl:attribute>
        <xsl:apply-templates/>
      </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
