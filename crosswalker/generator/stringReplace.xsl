<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="stringReplace">
        <xsl:param name="input"/>
        <xsl:param name="find"/>
        <xsl:param name="replace"/>
        <xsl:choose>
            <xsl:when test="contains($input, $find)">
                <xsl:value-of select="substring-before($input, $find)"/><xsl:value-of select="$replace"/>
                <xsl:call-template name="stringReplace">
                    <xsl:with-param name="input"><xsl:value-of select="substring-after($input, $find)"/></xsl:with-param>
                    <xsl:with-param name="find"><xsl:value-of select="$find"/></xsl:with-param>
                    <xsl:with-param name="replace"><xsl:value-of select="$replace"/></xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$input"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
