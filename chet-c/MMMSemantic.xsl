<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">



<!-- TOP LEVEL -->
<xsl:strip-space elements="brackets"/>

<xsl:template match="/div">
<xsl:element name="div">
  <xsl:attribute name="type">edition</xsl:attribute>
  <xsl:attribute name="lang"><xsl:value-of select="@lang"/></xsl:attribute><xsl:text>
  </xsl:text><ab><xsl:text>
    </xsl:text><lb n="1"/><xsl:apply-templates/><xsl:text>
  </xsl:text></ab><xsl:text>
</xsl:text></xsl:element>
</xsl:template>

<!--ABBREVIATIONS-->
<xsl:template match="abbr"><abbr><xsl:if test="@expan"><xsl:attribute name="expan"><xsl:value-of select="@expan"/></xsl:attribute></xsl:if><xsl:apply-templates/></abbr></xsl:template>

<!-- VARIOUS UTILITY FUNCTIONS, NEEDED IN A VARIETY OF PLACES -->
<xsl:include href="MMMUtility.xsl"/>


<!-- SECOND-ORDER TAGS, IN ALPHABETICAL ORDER, TOGETHER WITH THEIR SUPPORTING TEMPLATES -->

<!-- ANGLE BRACKETS -->
<xsl:include href="MMMAngleBrackets.xsl"/>

<!-- BRACKETS -->
<xsl:include href="MMMBrackets.xsl"/>

<!-- C (TEI) -->
<xsl:template match="c"><xsl:element name="c"><xsl:attribute name="type"><xsl:value-of select="type"/></xsl:attribute><xsl:apply-templates /></xsl:element></xsl:template>

<!-- CURLY BRACES -->
<xsl:template match="curlyBraces"><sic corr=""><xsl:apply-templates/></sic></xsl:template>

<!-- DOUBLE ANGLE BRACKETS -->
<xsl:include href="MMMDoubleAngleBrackets.xsl"/>

<!-- DOTS -->
<xsl:include href="MMMDot.xsl"/>

<!-- DOUBLE BRACKETS -->
<xsl:template match="doubleBrackets"><del rend="erasure"><xsl:apply-templates/></del></xsl:template>

<!-- DOUBLE PARENTHESES -->
<xsl:include href="MMMDoubleParentheses.xsl"/>

<!-- HALF BRACKETS -->
<xsl:template match="halfBrackets"></xsl:template>

<!-- HI (TEI) -->
<xsl:template match="hi"><xsl:element name="hi"><xsl:attribute name="rend"><xsl:value-of select="@rend"/></xsl:attribute><xsl:apply-templates/></xsl:element></xsl:template>

<!-- HYPHENS -->
<xsl:include href="MMMHyphen.xsl"/>

<!-- LB (TEI) -->
<xsl:template match="lb"><xsl:text>
</xsl:text><xsl:element name="lb"><xsl:attribute name="n"><xsl:value-of select="count(preceding::lb) + 2"/></xsl:attribute><xsl:if test="@type"><xsl:attribute name="type"><xsl:value-of select="@type"/></xsl:attribute></xsl:if></xsl:element></xsl:template>

<!-- PARENTHESES -->
<xsl:include href="MMMParentheses.xsl"/>

<!-- PLUSSES -->
<xsl:include href="MMMPlus.xsl"/>

<!-- SINGLE QUOTES -->
<xsl:template match="singleQuote"><add place="CHANGEME"><xsl:apply-templates/></add></xsl:template>

<!-- SLASH -->
<xsl:template match="slash"></xsl:template>

<!-- TEXT -->
<xsl:template match="text()">
  <xsl:choose>
    <xsl:when test="./following-sibling::*[1][name(.) = 'combiningStrikeThrough']"><xsl:value-of select="substring(., 1, string-length(.) - 1)"/><hi rend="strikethrough"><xsl:value-of select="substring(., string-length(.))"/></hi></xsl:when>
    <xsl:when test="./following-sibling::*[1][name(.) = 'combiningSubscriptDot']"><xsl:value-of select="substring(., 1, string-length(.) - 1)"/><unclear><xsl:value-of select="substring(., string-length(.))"/></unclear></xsl:when>
    <xsl:when test="./following-sibling::*[1][name(.) = 'combiningSuperscriptLine']"><xsl:value-of select="substring(., 1, string-length(.) - 1)"/><hi rend="superscriptline"><xsl:value-of select="substring(., string-length(.))"/></hi></xsl:when>
    <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- UNCLEAR (TEI) -->
<xsl:template match="unclear"><unclear><xsl:apply-templates/></unclear></xsl:template>

<!-- no template for questionMark b/c we have to test for it in various contexts -->
<!-- what to do about apostrophe, which is really a screw up for singleQuote, except when it's not -->
<!-- what to do about double slashes -->
<!-- what to do about non-closing brackets: [$ vel sim -->

</xsl:stylesheet>
