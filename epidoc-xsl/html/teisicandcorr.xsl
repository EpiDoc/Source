<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:template match="tei:sic[@corr]">
        <xsl:call-template name="docorrectsubstitution">
            <xsl:with-param name="sic" select="."/>
            <xsl:with-param name="corr" select="@corr"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:corr[@sic]">
        <xsl:call-template name="docorrectsubstitution">
            <xsl:with-param name="sic" select="@sic"/>
            <xsl:with-param name="corr" select="."/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="docorrectsubstitution">
        <xsl:param name="sic"/>
        <xsl:param name="corr"/>
        <xsl:choose>
            <xsl:when test="string-length($sic) = 1 and string-length($corr) = 1">
                <xsl:element name="span"><xsl:call-template name="propagateattrs"/><xsl:attribute name="class">correction</xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$sic"/></xsl:attribute>&lt;<xsl:value-of select="$corr"/>&gt;</xsl:element>
            </xsl:when>
            <xsl:when test="string-length($sic) &gt; 0 and string-length($corr) = 0">
               <xsl:element name="span"><xsl:call-template name="propagateattrs"/><xsl:attribute name="class">correction</xsl:attribute>{<xsl:value-of select="$sic"/>}</xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="span"><xsl:call-template name="propagateattrs"/><xsl:attribute name="class">correction</xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$sic"/></xsl:attribute>&#x231C;<xsl:value-of select="$corr"/>&#x231D;</xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
   <!-- in EpiDoc, a plain sic means unintelligible -->
    <xsl:template match="tei:sic">
       <xsl:element name="span">
          <xsl:call-template name="propagateattrs"/>
          <xsl:attribute name="class">unintelligible</xsl:attribute>
          <xsl:choose>
             <xsl:when test="ancestor-or-self::*/@lang='lat'"><xsl:value-of select="translate(text(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/></xsl:when>
             <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
          </xsl:choose>
       </xsl:element>
    </xsl:template>
</xsl:stylesheet>
