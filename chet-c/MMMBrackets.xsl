<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="brackets">
  <xsl:variable name="gotArabicNumeral"><xsl:call-template name="testArabicNumeral"/></xsl:variable>
	<xsl:choose>
		<xsl:when test="dot or hyphen or circa or starts-with($gotArabicNumeral, 'yes')"><xsl:call-template name="gap"><xsl:with-param name="gotArabic" select="$gotArabicNumeral"/></xsl:call-template></xsl:when>
		<xsl:otherwise><supplied reason="lost"><xsl:apply-templates/></supplied></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template name="gap">
  <xsl:param name="gotArabic"/>
  <!-- test for gap uncertainty -->
  <!-- a questionMark element anywhere inside the brackets is interpreted as an indication that this could have been a vacat -->
  <xsl:variable name="gapCert">
    <xsl:choose>
      <xsl:when test="questionMark">no</xsl:when>
      <xsl:otherwise>yes</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- test for extent uncertainty -->
  <!-- a circa element anywhere inside the brackets is interpreted as an indication of imprecision in the extent of the gap -->
  <xsl:variable name="extentCert">
    <xsl:choose>
      <xsl:when test="circa">no</xsl:when>
      <xsl:otherwise>yes</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- determine unit -->
  <!-- there are rather complicated rules here, which may still be wrong in some cases? -->
  <xsl:variable name="rawExtentUnit"><xsl:apply-templates select="node()" mode="bracketExtentUnit"/></xsl:variable>
  <xsl:variable name="mixture"><xsl:call-template name="bracketAlphaText"><xsl:with-param name="victim" select="normalize-space($rawExtentUnit)"/></xsl:call-template></xsl:variable>
  <xsl:variable name="unit">
    <xsl:choose>
      <xsl:when test="name(*[1])='dot'">character</xsl:when>
      <xsl:when test="name(*[1])='circa'">character</xsl:when>
      <xsl:when test="name(*[1])='hyphen'">
        <xsl:choose>
          <xsl:when test="$mixture='numeric'">character</xsl:when>
          <xsl:when test="$mixture='empty'">character</xsl:when>
          <xsl:otherwise><xsl:call-template name="bracketStripNumeric"><xsl:with-param name="victim"><xsl:value-of select="normalize-space($rawExtentUnit)"/></xsl:with-param></xsl:call-template></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
<!--      <xsl:otherwise>
        <xsl:if test="starts-with($gotArabic, 'yes')">character</xsl:if>
      </xsl:otherwise> -->
    </xsl:choose>
  </xsl:variable>
  
  <!-- determine extent -->
  <xsl:variable name="extent">
  <xsl:choose>
    <xsl:when test="string-length($rawExtentUnit) = 0 or $rawExtentUnit=' '">
      <xsl:choose>
        <xsl:when test="hyphen"><xsl:value-of select="count(hyphen)"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="count(dot)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="serialOutputNumerals"><xsl:with-param name="victim" select="$rawExtentUnit"/></xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:variable>
  
  <!-- test for unit uncertainty -->
  <!-- this has to be done last, because the meaning of a hyphen depends on the type of units -->
  <xsl:variable name="unitCert">
    <xsl:choose>
      <xsl:when test="hyphen and $unit='character'">no</xsl:when>
      <xsl:otherwise>yes</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <!-- write the xml -->
  <!-- generate an id here, because we need it at this scope level -->
  <xsl:variable name="generatedID">GAP<xsl:value-of select="generate-id()"/></xsl:variable>

  <!-- write the gap tag and its attributes -->
  <xsl:element name="gap">
    <xsl:attribute name="id"><xsl:value-of select="$generatedID"/></xsl:attribute>
    <xsl:attribute name="reason">lost</xsl:attribute>
    <xsl:attribute name="extent"><xsl:value-of select="$extent"/></xsl:attribute>
    <xsl:attribute name="unit"><xsl:value-of select="$unit"/></xsl:attribute>
  </xsl:element>
  
  <!-- write any needed certainty tags and their attributes -->
  <xsl:if test="$gapCert='no'">
    <xsl:element name="certainty">
      <xsl:attribute name="target"><xsl:value-of select="$generatedID"/></xsl:attribute>
      <xsl:attribute name="locus">#gi</xsl:attribute>
      <xsl:attribute name="degree">lesser</xsl:attribute>
      <xsl:attribute name="assertedValue">space</xsl:attribute>
    </xsl:element>
  </xsl:if>
  
  <xsl:if test="$extentCert='no'">
    <xsl:element name="certainty">
      <xsl:attribute name="target"><xsl:value-of select="$generatedID"/></xsl:attribute>
      <xsl:attribute name="locus">extent</xsl:attribute>
      <xsl:attribute name="degree">lesser</xsl:attribute>
    </xsl:element>
  </xsl:if>
  
  <xsl:if test="$unitCert='no'">
    <xsl:element name="certainty">
      <xsl:attribute name="target"><xsl:value-of select="$generatedID"/></xsl:attribute>
      <xsl:attribute name="locus">unit</xsl:attribute>
      <xsl:attribute name="degree">lesser</xsl:attribute>
    </xsl:element>
  </xsl:if>
</xsl:template>


<xsl:template match="node()" mode="bracketExtentUnit">
  <xsl:choose>
    <xsl:when test="name()=''"><xsl:value-of select="normalize-space(.)"/></xsl:when>
    <xsl:when test="name()='dot'">
      <xsl:choose>
        <xsl:when test="count(../text()) > 0 and count(../dot) > 1 and generate-id() != generate-id(../dot[1]) and generate-id() != generate-id(../dot[last()]) and name(preceding-sibling::node()[1]) != 'dot' and name(following-sibling::node()[1]) != 'dot'">.</xsl:when>
        <xsl:when test="count(../dot) = 1 and count(../hyphen) > 0">.</xsl:when>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>



<xsl:template name="bracketStripNumeric">
  <xsl:param name="victim"/>
  <xsl:if test="not (starts-with($victim, '1') or starts-with($victim, '2') or starts-with($victim, '3') or starts-with ($victim, '4') or starts-with ($victim, '5') or starts-with($victim, '6') or starts-with($victim, '7') or starts-with($victim, '8') or starts-with ($victim, '9') or starts-with ($victim, '0') or starts-with($victim, '.'))"><xsl:value-of select="substring($victim, 1, 1)"/></xsl:if>
  <xsl:if test="string-length($victim) > 1"><xsl:call-template name="bracketStripNumeric"><xsl:with-param name='victim'><xsl:value-of select="substring($victim, 2, string-length($victim)-1)"/></xsl:with-param></xsl:call-template></xsl:if>
</xsl:template>

<xsl:template name="bracketAlphaText">
  <xsl:param name="victim"/>
  <!-- <p>Victim: <xsl:value-of select="$victim"/></p> -->
  <xsl:choose>
    <xsl:when test="string-length($victim) = 0">empty</xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="not (starts-with($victim, '1') or starts-with($victim, '2') or starts-with($victim, '3') or starts-with ($victim, '4') or starts-with ($victim, '5') or starts-with($victim, '6') or starts-with($victim, '7') or starts-with($victim, '8') or starts-with ($victim, '9') or starts-with ($victim, '0') or starts-with ($victim, ' '))">alphanumeric</xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test="string-length($victim) = 1">numeric</xsl:when>
            <xsl:otherwise><xsl:call-template name="bracketAlphaText"><xsl:with-param name='victim'><xsl:value-of select="substring($victim, 2, string-length($victim)-1)"/></xsl:with-param></xsl:call-template></xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="testArabicNumeral">
  <xsl:for-each select="text()">
    <xsl:choose>
      <xsl:when test="contains(., '1') or contains(., '2') or contains(., '3') or contains(., '4') or contains(., '5') or contains(., '6') or contains(., '7') or contains(., '8') or contains(., '9') or contains(., '0')">yes</xsl:when>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>



</xsl:stylesheet>