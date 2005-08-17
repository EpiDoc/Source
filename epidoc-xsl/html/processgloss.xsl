<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="processgloss">
        <xsl:param name="uriprefix"/>
        <xsl:choose>
            <xsl:when test="@key">
                <xsl:element name="a">
                    <xsl:attribute name="class">externalgloss</xsl:attribute>
                    <xsl:attribute name="href"><xsl:value-of select="$uriprefix"/>#<xsl:value-of select="@key"/></xsl:attribute>
                    <xsl:if test="@reg"><xsl:attribute name="title"><xsl:value-of select="@reg"/></xsl:attribute></xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@reg and not(@key)">
                <xsl:element name="a">
                    <xsl:attribute name="class">internalgloss</xsl:attribute>
                    <xsl:if test="@reg"><xsl:attribute name="title"><xsl:value-of select="@reg"/></xsl:attribute></xsl:if>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
