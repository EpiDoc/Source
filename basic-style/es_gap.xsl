<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="gap">
    
    <xsl:variable name="myid" select="@id"/>

    <xsl:variable name="symbol">
      <xsl:choose>
        <xsl:when test="@unit!='character'">-</xsl:when>
        <xsl:when test="@unit='character' and //certainty[@target=$myid and @locus='unit']">-</xsl:when>
        <xsl:otherwise>&#xB7;</xsl:otherwise>       <!-- middle dot -->
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="enumerate">
      <xsl:choose>
        <xsl:when test="@unit!='character'">no</xsl:when>
        <xsl:when test="@unit='character' and //certainty[@target=$myid and @locus='unit']">
          <xsl:choose>
            <xsl:when test="@extent &lt;= $enumerateLimitHyphen">yes</xsl:when>
            <xsl:otherwise>no</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="$symbol='dot'">
          <xsl:choose>
            <xsl:when test="@extent &lt;= $enumerateLimitDot">yes</xsl:when>
            <xsl:otherwise>no</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="unittag">
      <xsl:choose>
        <xsl:when test="@unit != 'character'"><xsl:value-of select="@unit"/></xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="circatag">
      <xsl:choose>
        <xsl:when test="//certainty[@target=$myid and @locus='extent']"><xsl:text> c. </xsl:text></xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="questiontag">
      <xsl:choose>
        <xsl:when test="//certainty[@target=$myid and @locus='#gi']">?</xsl:when>
        <xsl:otherwise></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
  </xsl:template>
</xsl:stylesheet>
