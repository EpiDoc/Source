<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="corr[@sic]"><span style="vertical-align: super;">&#x231C;</span><xsl:element name="a"><xsl:attribute name="class">editionlink</xsl:attribute><xsl:attribute name="href">#correction<xsl:value-of select="count(preceding::sic[@corr] | corr[@sic])+1"/></xsl:attribute><xsl:value-of select="."/></xsl:element><span style="vertical-align: super;">&#x231D;</span></xsl:template>
  
  <xsl:template match="sic[@corr]"><span style="letter-spacing: -0.3em;"><span style="vertical-align: super;">&#x231C;</span><xsl:element name="a"><xsl:attribute name="class">editionlink</xsl:attribute><xsl:attribute name="href">#correction<xsl:value-of select="count(preceding::sic[@corr] | corr[@sic])+1"/></xsl:attribute><xsl:value-of select="@corr"/></xsl:element><span style="vertical-align: super;">&#x231D;</span></span></xsl:template>
  
  <xsl:template name="enumerateCorrections">
    <xsl:if test="count(//sic[@corr] | //corr[@sic]) > 0">
      <h2>Editorial Corrections:</h2>
      <ul class="plainList">
        <xsl:for-each select="//sic[@corr] | //corr[@sic]">
          <xsl:element name="li"><xsl:attribute name="id">correction<xsl:value-of select="count(preceding::sic[@corr] | corr[@sic])+1"/></xsl:attribute><span class="linenumber"><xsl:value-of select="preceding::lb[1]/@n"/></span><xsl:text>  </xsl:text><xsl:choose><xsl:when test="name(.)='sic'"><xsl:element name="span"><xsl:attribute name="class"><xsl:value-of select="ancestor-or-self::*[@lang]/@lang"/></xsl:attribute><xsl:value-of select="./@corr"/></xsl:element> is an editorial correction for <xsl:element name="span"><xsl:attribute name="class"><xsl:value-of select="ancestor-or-self::*[@lang]/@lang"/></xsl:attribute><xsl:value-of select="."/></xsl:element></xsl:when><xsl:otherwise><xsl:element name="span"><xsl:attribute name="class"><xsl:value-of select="ancestor-or-self::*[@lang]/@lang"/></xsl:attribute><xsl:value-of select="."/></xsl:element> is an editorial correction for <xsl:element name="span"><xsl:attribute name="class"><xsl:value-of select="ancestor-or-self::*[@lang]/@lang"/></xsl:attribute><xsl:value-of select="./@sic"/></xsl:element></xsl:otherwise></xsl:choose></xsl:element>
        </xsl:for-each>
      </ul>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
