<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:template match="listBibl">
	  <xsl:variable name="mylevel"><xsl:value-of select="count(ancestor::div|ab|p)"/></xsl:variable>
    <xsl:text>
</xsl:text>
    <xsl:call-template name="utilIndent"><xsl:with-param name="indentSpaces" select="($mylevel+2)*$tabWidth"/></xsl:call-template>
       <xsl:for-each select="bibl | biblStruct | biblFull"><xsl:text>
</xsl:text>
        <xsl:if test="count(preceding-sibling::bibl) + count(preceding-sibling::biblStruct) + count(preceding-sibling::biblFull) > 0"><xsl:text> = </xsl:text></xsl:if>
        <xsl:if test="./@id"><xsl:element name="a"><xsl:attribute name="id"><xsl:value-of select="./@id"/></xsl:attribute><xsl:attribute name="name"><xsl:value-of select="./@id"/></xsl:attribute></xsl:element></xsl:if><xsl:apply-templates select="." mode="listBibl"/>
      </xsl:for-each>
      <xsl:text>
</xsl:text>
      <xsl:call-template name="utilIndent"><xsl:with-param name="indentSpaces" select="($mylevel+2)*$tabWidth"/></xsl:call-template>
    <xsl:text>
</xsl:text>
  </xsl:template>

  
  <xsl:template match="biblStruct" mode="listBibl">
    <xsl:choose>
      <xsl:when test="analytic">
        <xsl:choose>
          <xsl:when test="analytic/title/@type='abbreviated'"><xsl:apply-templates select="analytic/title[@type='abbreviated']" mode="listBibl"/> </xsl:when>
          <xsl:when test="analytic/title">"<xsl:apply-templates select="analytic/title" mode="listBibl"/>" </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="monogr" mode="listBibl"/>
      </xsl:when>
      <xsl:otherwise>
        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<xsl:template match="author|editor" mode="listBibl"></xsl:template>

  <xsl:template match="monogr" mode="listBibl">
    <xsl:choose>
      <xsl:when test="title/@level='j'">
        <span class="booktitle"><xsl:apply-templates select="title[@level='j']" mode="listBibl"/></span>
        <xsl:if test="imprint/biblScope/@type='volume'"><xsl:text> </xsl:text><xsl:value-of select="imprint/biblScope[@type='volume']"/></xsl:if>
        <xsl:if test="imprint/date"><xsl:text> </xsl:text><xsl:if test="imprint/biblScope/@type='volume'">(</xsl:if><xsl:value-of select="imprint/date"/><xsl:if test="imprint/biblScope/@type='volume'">)</xsl:if></xsl:if>
        <xsl:if test="imprint/biblScope/@type='pages'"><xsl:text>, </xsl:text><xsl:value-of select="imprint/biblScope[@type='pages']"/></xsl:if>
        <xsl:if test="imprint/biblScope/@type='numbers'">
          <xsl:choose>
            <xsl:when test="imprint/biblScope/@type='volume' and imprint/date and not(imprint/biblScope/@type='pages')"><xsl:text> no. </xsl:text></xsl:when>
            <xsl:otherwise>.</xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="imprint/biblScope[@type='numbers']"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="title/@level='m'">
        <span class="booktitle"><xsl:apply-templates select="title[@level='m']" mode="listBibl"/></span>
        <xsl:if test="imprint/biblScope/@type='volume'"><xsl:text> </xsl:text><xsl:value-of select="imprint/biblScope[@type='volume']"/></xsl:if>
        <xsl:if test="imprint/date and title[@type='abbreviated'] != 'EDH'"><xsl:text> </xsl:text><xsl:if test="imprint/biblScope/@type='volume'">(</xsl:if><xsl:value-of select="imprint/date"/><xsl:if test="imprint/biblScope/@type='volume'">)</xsl:if></xsl:if>
        <xsl:if test="imprint/biblScope/@type='pages'"><xsl:text>, </xsl:text><xsl:value-of select="imprint/biblScope[@type='pages']"/></xsl:if>
        <xsl:if test="imprint/biblScope/@type='numbers'">
          <xsl:choose>
            <xsl:when test="imprint/biblScope/@type='volume' and imprint/date and not(imprint/biblScope/@type='pages')"><xsl:text> no. </xsl:text></xsl:when>
            <xsl:when test="title[@type='abbreviated'] = 'EDH'"><xsl:text> </xsl:text></xsl:when>
            <xsl:otherwise>.</xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="imprint/biblScope[@type='numbers']"/>
        </xsl:if>
      </xsl:when>
      <xsl:when test="title">
        <span class="booktitle"><xsl:apply-templates select="title" mode="listBibl"/></span>
      </xsl:when>
    </xsl:choose>
   
  </xsl:template>
  <xsl:template match="title" mode="listBibl"><xsl:apply-templates /></xsl:template>
</xsl:stylesheet>


