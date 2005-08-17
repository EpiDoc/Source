<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="div[@type='edition']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="cb">
        
    </xsl:template>
    <xsl:template match="lb">
        <xsl:choose>
            <xsl:when test="ancestor::div[@type='edition']">
                <xsl:element name="br">
                    <xsl:variable name="ancestor-id" select="ancestor::*[@id]/@id"/>
                    <xsl:choose>
                        <xsl:when test="@id"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute></xsl:when>
                        <xsl:when test="@n"><xsl:attribute name="id"><xsl:value-of select="$ancestor-id"/>-<xsl:value-of select="@n"/></xsl:attribute></xsl:when>
                        <xsl:otherwise><xsl:attribute name="id"><xsl:value-of select="generate-id(.)"/></xsl:attribute></xsl:otherwise>
                    </xsl:choose>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="."></xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
