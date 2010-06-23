<?xml version="1.0"?>

<!-- |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| -->
<!-- |XX          Gabriel BODARD 2008-11-20              XX| -->
<!-- |XX      w/contribution from TE,HC,EM,RV          XX| -->
<!-- |XX         Last update 2010-06-14                         XX| -->
<!-- |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns="http://www.tei-c.org/ns/1.0">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

  <!-- |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| -->
  <!-- |XX          copy all existing elements                     XX| -->
  <!-- |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| -->

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
          <xsl:value-of select="translate(@type,' +','-_')"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <!-- |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| -->
  <!-- |XX                   copy all comments                       XX| -->
  <!-- |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| -->

  <xsl:template match="//comment()">
    <xsl:comment>
      <xsl:value-of select="."/>
    </xsl:comment>
  </xsl:template>

  <!-- |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| -->
  <!-- |XX                           EXCEPTIONS                     XX| -->
  <!-- |XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX| -->

  <xsl:template match="TEI.2">
    <xsl:processing-instruction name="oxygen ">
      RNGSchema="file:///C:/Documents and Settings/gbodard/Desktop/sourceforge/schema/tei-epidoc.rng"
      type="xml"</xsl:processing-instruction>
    <!--
      RNGSchema="http://www.stoa.org/epidoc/schema/8/tei-epidoc.rng"
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

  <xsl:template match="certainty"/>
  <!--STRIPPING CERTAINTY ELEMENTS BECAUSE IN PRACTICE ALL FOLLOW GAP OR SPACE-->

  <!--<xsl:element name="{local-name()}">
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
  </xsl:template>-->

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
      <xsl:apply-templates/>
      <xsl:if test="@exact=('notAfter','notBefore')">
        <xsl:element name="precision">
          <xsl:attribute name="match">
            <xsl:text>../</xsl:text>
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
    </xsl:element>
  </xsl:template>

  <xsl:template match="div[@type='description']"/>
  <xsl:template match="div[@type='history'][@subtype='locations']"/>

  <xsl:template match="div[@type=('edition','translation')]">
    <xsl:element name="{local-name()}">
      <xsl:copy-of
        select="@*[not(local-name()=('lang','default','org','sample','part','full','status','anchored'))]"/>
      <xsl:if test="@lang">
        <xsl:attribute name="xml:lang">
          <xsl:value-of select="@lang"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:attribute name="xml:space">
        <xsl:text>preserve</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="encodingDesc">
    <xsl:element name="{local-name()}">
      <xsl:element name="p">
        <xsl:text>Marked-up according to the EpiDoc Guidelines version 8</xsl:text>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="figure">
    <xsl:element name="figure">
      <xsl:element name="graphic">
        <xsl:attribute name="url">
          <xsl:value-of select="@href"/>
        </xsl:attribute>
      </xsl:element>
      <xsl:element name="head">
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:element>
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
      <xsl:if test="@desc">
        <xsl:element name="desc">
          <xsl:value-of select="@desc"/>
        </xsl:element>
      </xsl:if>
      <xsl:if test="@id and following-sibling::certainty">
        <xsl:element name="certainty">
          <xsl:attribute name="match">
            <xsl:text>..</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="locus">
            <xsl:text>name</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
    </xsl:element>
  </xsl:template>

  <xsl:template match="keywords">
    <xsl:element name="{local-name()}">
      <xsl:attribute name="scheme">
        <xsl:text>IRCyr</xsl:text>
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
          <xsl:copy-of select="@*[not(local-name()=('type','dim','precision','value'))]"/>
          <xsl:if test="@precision='circa'">
            <xsl:attribute name="precision">
              <xsl:text>low</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="@value">
            <xsl:attribute name="quantity">
              <xsl:value-of select="@value"/>
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
          <!--<xsl:value-of select="local-name()"/>
          <xsl:text>AL#</xsl:text>-->
          <xsl:value-of select="@reg"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="publicationStmt">
    <xsl:element name="{local-name()}">
      <xsl:element name="authority">
        <xsl:text>Centre for Computing in the Humanities, King's College London</xsl:text>
      </xsl:element>
      <xsl:element name="idno">
        <xsl:attribute name="type">
          <xsl:text>filename</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="ancestor::TEI.2/@id"/>
      </xsl:element>
      <xsl:if test="starts-with(//titleStmt/title,'JMR:')">
        <xsl:for-each select="tokenize(//titleStmt/title,'; ')">
          <xsl:choose>
            <xsl:when test="starts-with(.,'JMR')">
              <xsl:element name="idno">
                <xsl:attribute name="type">
                  <xsl:text>JMR</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="substring-after(.,'JMR: ')"/>
              </xsl:element>
            </xsl:when>
            <xsl:when test="starts-with(.,'Excel')">
              <xsl:element name="idno">
                <xsl:attribute name="type">
                  <xsl:text>Excel</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="substring-after(.,'Excel: ')"/>
              </xsl:element>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:if>
      <xsl:element name="availability">
        <xsl:apply-templates select="p"/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="revisionDesc">
    <xsl:element name="{local-name()}">
      <xsl:element name="change">
        <xsl:attribute name="when">
          <xsl:value-of select="substring(string(current-date()),1,10)"/>
        </xsl:attribute>
        <xsl:attribute name="who">
          <xsl:text>GB</xsl:text>
        </xsl:attribute>
        <xsl:text>Converted from TEI P4 (EpiDoc DTD v. 6) to P5 (EpiDoc RNG schema v. 8)</xsl:text>
      </xsl:element>
      <xsl:for-each select="change">
        <xsl:element name="{local-name()}">
          <xsl:attribute name="when">
            <xsl:choose>
              <xsl:when test="contains(date, '.')">
                <xsl:value-of select="substring(date,7,4)"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring(date,4,2)"/>
                <xsl:text>-</xsl:text>
                <xsl:value-of select="substring(date,1,2)"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="date"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="who">
            <xsl:value-of select="normalize-space(respStmt)"/>
          </xsl:attribute>
          <xsl:value-of select="normalize-space(item)"/>
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
      <xsl:when test="@type='material'">
        <xsl:element name="material">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
        <xsl:element name="{local-name()}">
          <xsl:copy-of select="@*[not(local-name() = ('reg','full','cert'))]"/>
          <xsl:if test="not(@type)">
            <xsl:attribute name="type">
              <xsl:text>RS-NEEDS-TYPE</xsl:text>
            </xsl:attribute>
          </xsl:if>
          <xsl:if test="@reg">
            <xsl:attribute name="key">
              <!--<xsl:value-of select="@type"/>
              <xsl:text>AL#</xsl:text>-->
              <xsl:value-of select="@reg"/>
            </xsl:attribute>
          </xsl:if>
          <xsl:apply-templates/>
          <xsl:if test="@cert='low'">
            <xsl:element name="certainty">
              <xsl:attribute name="match">
                <xsl:text>..</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="locus">
                <xsl:text>value</xsl:text>
              </xsl:attribute>
            </xsl:element>
          </xsl:if>
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

  <xsl:template match="sic[not(ancestor::choice)]">
    <xsl:element name="surplus">
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="sourceDesc">
    <xsl:element name="{local-name()}">
      <xsl:element name="msDesc">
        <xsl:element name="msIdentifier">
          <xsl:if test="//rs[@type='invNo']">
            <xsl:attribute name="type">
              <xsl:text>invNo</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="//rs[@type='invNo'][1]"/>
          </xsl:if>
        </xsl:element>
        <xsl:if test="//rs[@type='invNo'][2]">
          <xsl:element name="msIdentifier">
            <xsl:attribute name="type">
              <xsl:text>invNo</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="//rs[@type='invNo'][2]"/>
          </xsl:element>
        </xsl:if>
        <xsl:element name="physDesc">
          <xsl:element name="objectDesc">
            <xsl:element name="supportDesc">
              <xsl:element name="support">
                <xsl:apply-templates select="//div[@type='description'][@subtype='monument']/p"/>
              </xsl:element>
            </xsl:element>
            <xsl:element name="layoutDesc">
              <xsl:for-each select="//div[@type='description'][@subtype='text']/p">
                <xsl:element name="layout">
                  <xsl:apply-templates/>
                </xsl:element>
              </xsl:for-each>
            </xsl:element>
          </xsl:element>
          <xsl:element name="handDesc">
            <xsl:for-each select="//div[@type='description'][@subtype='letters']/p">
              <xsl:element name="handNote">
                <xsl:apply-templates/>
              </xsl:element>
            </xsl:for-each>
          </xsl:element>
        </xsl:element>
        <xsl:element name="history">
          <xsl:element name="origin">
            <xsl:element name="p">
              <xsl:apply-templates select="//rs[@type='origLocation']/node()"/>
            </xsl:element>
            <xsl:element name="origDate">
              <xsl:for-each select="//div[@type='description'][@subtype='date']//date[1]">
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
                <xsl:if test="following-sibling::rs[@type='criteria']">
                  <xsl:attribute name="evidence">
                    <xsl:for-each select="following-sibling::rs[@type='criteria']">
                      <xsl:value-of select="translate(.,' ','-')"/>
                      <xsl:if test="following-sibling::rs[@type='criteria']">
                        <xsl:text>-</xsl:text>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:attribute>
                </xsl:if>
              </xsl:for-each>
              <xsl:for-each select="//div[@type='description'][@subtype='date']/p">
                <xsl:value-of select="normalize-space(.)"/>
              </xsl:for-each>
            </xsl:element>
            <xsl:if
              test="//div[@type='description'][@subtype='date']//date/@exact=('notAfter','notBefore')">
              <xsl:element name="precision">
                <xsl:attribute name="match">
                  <xsl:text>//origDate/</xsl:text>
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
          </xsl:element>
          <xsl:element name="provenance">
            <xsl:element name="listEvent">
              <xsl:element name="event">
                <xsl:attribute name="type">
                  <xsl:text>found</xsl:text>
                </xsl:attribute>
                <xsl:element name="p">
                  <xsl:apply-templates select="//rs[@type='found']/node()"/>
                </xsl:element>
              </xsl:element>
              <xsl:element name="event">
                <xsl:attribute name="type">
                  <xsl:text>observed</xsl:text>
                </xsl:attribute>
                <xsl:element name="p">
                  <xsl:apply-templates select="//rs[@type='lastLocation']/node()"/>
                </xsl:element>
              </xsl:element>
            </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
      <xsl:if test=".//bibl">
        <xsl:comment>
          <xsl:copy-of select="normalize-space(.)"/>
        </xsl:comment>
      </xsl:if>
    </xsl:element>
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
      <xsl:if test="@id and following-sibling::certainty">
        <xsl:element name="certainty">
          <xsl:attribute name="match">
            <xsl:text>..</xsl:text>
          </xsl:attribute>
          <xsl:attribute name="locus">
            <xsl:text>name</xsl:text>
          </xsl:attribute>
        </xsl:element>
      </xsl:if>
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
