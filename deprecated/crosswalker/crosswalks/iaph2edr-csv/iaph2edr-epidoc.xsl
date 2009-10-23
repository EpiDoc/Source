<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="div[@type='edition']">
        <xsl:variable name="divtypeedition"><xsl:apply-templates/></xsl:variable>
        <xsl:value-of select="normalize-space($divtypeedition)"/>
    </xsl:template>
    
    <xsl:template match="*[ancestor::div/@type='edition']"><xsl:apply-templates/></xsl:template>
    <xsl:template match="ab"><xsl:apply-templates /></xsl:template>
    
<!--    <xsl:include href="../../epidoc-xsl/text/app.xsl"/>
    <xsl:include href="../../epidoc-xsl/text/gap.xsl"/>  -->
    <xsl:template match="head" />
    <xsl:template match="lb[not(@type)]" ><xsl:if test="count(preceding::lb) &gt; 0">/</xsl:if></xsl:template>
    <xsl:template match="lb[@type='worddiv']" >=/</xsl:template>
    <xsl:template match="orig" ><xsl:apply-templates/></xsl:template>
<!--    <xsl:include href="../epidoc-xsl/text/space.xsl"/> -->
    <xsl:template match="unclear" >
        <xsl:call-template name="iterim-postfix">
            <xsl:with-param name="input"><xsl:value-of select="."/></xsl:with-param>
            <xsl:with-param name="postfix">&#x323;</xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="iterim">
        <xsl:param name="string"/>
        <xsl:param name="count"/>
        <xsl:if test="$count &gt; 0">
            <xsl:value-of select="$string"/>
            <xsl:call-template name="iterim">
                <xsl:with-param name="count"><xsl:value-of select="$count - 1"/></xsl:with-param>
                <xsl:with-param name="string"><xsl:value-of select="$string"/></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="iterim-postfix">
        <xsl:param name="input" />
        <xsl:param name="postfix" />
        <xsl:value-of select="substring($input, 1, 1)" />
        <xsl:value-of select="$postfix" />
        <xsl:if test="string-length($input) &gt; 1">
            <xsl:call-template name="iterim-postfix">
                <xsl:with-param name="input">
                    <xsl:value-of select="substring($input, 2)" />
                </xsl:with-param>
                <xsl:with-param name="postfix">
                    <xsl:value-of select="$postfix" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
