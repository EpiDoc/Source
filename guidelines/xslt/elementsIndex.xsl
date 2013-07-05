<?xml version="1.0"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:t="http://www.tei-c.org/ns/1.0" 
  exclude-result-prefixes="t" version="2.0">
  
  <xsl:output method="xml" encoding="UTF-8"/>
  
  <xsl:template match="t:divGen[@type='elementIndex']">
    <dl>
      <xsl:for-each-group select="//t:specDesc" group-by="@key">
        <xsl:sort select="@key"/>
        <xsl:element name="dt">
          <span class="gi"><xsl:value-of select="current-grouping-key()"/></span>
        </xsl:element>
        <dd>
        <xsl:for-each select="current-group()">
          <a href="{concat(ancestor::t:div[parent::t:body]/@xml:id,'.html')}">
            <xsl:value-of select="ancestor::t:div[parent::t:body]/t:head[1]"/>
          </a>
          <xsl:if test="not(position() = last())">
            <xsl:element name="br"/>
          </xsl:if>
        </xsl:for-each>
        </dd>
      </xsl:for-each-group>      
    </dl>
  </xsl:template>

  
  
  
</xsl:stylesheet>
