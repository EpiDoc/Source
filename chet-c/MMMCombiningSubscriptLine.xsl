<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="hi[@rend='subscriptline']">
  <xsl:if test="name(preceding-sibling::node()) != 'hi' and preceding-sibling::node()@rend='subscriptline'">
    <xsl:variable name="thisExtent"><xsl:call-template name="countCombiningSubscriptLines"><xsl:with-param name="thisCount">0</xsl:with-param><xsl:with-param name="thisList" select="following-sibling::node()"/></xsl:call-template></xsl:variable>
    <app>
      <rdg resp="CHANGEME"><xsl:element name="gap"><xsl:attribute name="reason">lost</xsl:attribute><xsl:attribute name="extent"><xsl:value-of select="$thisExtent;"/></xsl:attribute><xsl:attribute name="unit">character</xsl:attribute></xsl:element></rdg>
      <rdg resp="CHANGEMETOO"><xsl:value-of select="$this
  </xsl:if>
</xsl:template>

<xsl:template name="countCombiningSubscriptLines">
  <xsl:param name="thisCount"/>
  <xsl:param name="thisList"/>
  <xsl:choose>
    <xsl:when test="name(following-sibling::node()) = 'hi' and following-sibling::node()@rend='subscriptline'">
    
    </xsl:when>
    <xsl:otherwise>
    
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
</xsl:stylesheet>
