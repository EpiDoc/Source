<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="serialOutputNumerals">
  <xsl:param name="victim"/>
  <xsl:variable name="tempVictim"><xsl:value-of select="normalize-space($victim)"/></xsl:variable>
  <xsl:if test="starts-with($tempVictim, '1') or starts-with($tempVictim, '.') or starts-with($tempVictim, ',') or starts-with($tempVictim, '2') or starts-with($tempVictim, '3') or starts-with($tempVictim, '4') or starts-with($tempVictim, '5') or starts-with($tempVictim, '6') or starts-with($tempVictim, '7') or starts-with($tempVictim, '8') or starts-with($tempVictim, '9') or starts-with($tempVictim, '0')">
    <xsl:value-of select="substring($tempVictim, 1, 1)"/>
  </xsl:if>
  <xsl:if test="string-length($tempVictim)>1">
    <xsl:call-template name="serialOutputNumerals">
      <xsl:with-param name='victim'><xsl:value-of select="substring($tempVictim, 2, string-length($tempVictim)-1)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="serialOutputAlphabet">
  <xsl:param name="victim"/>
  <xsl:variable name="tempVictim"><xsl:value-of select="normalize-space($victim)"/></xsl:variable>
  <xsl:if test="starts-with(translate($tempVictim, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'),'A')">
    <xsl:value-of select="substring($tempVictim, 1, 1)"/>
  </xsl:if>
  <xsl:if test="string-length($tempVictim)>1">
    <xsl:call-template name="serialOutputAlphabet">
      <xsl:with-param name='victim'><xsl:value-of select="substring($tempVictim, 2, string-length($tempVictim)-1)"/></xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="hyphen" mode="error">-</xsl:template>
<xsl:template match="dot" mode="error">.</xsl:template>
<xsl:template match="parentheses" mode="error">(<xsl:apply-templates/>)</xsl:template>

</xsl:stylesheet>
