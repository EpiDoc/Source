<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
    <xsl:template match="tei:title[@type='abbreviated']">
        <xsl:element name="a">
            <xsl:attribute name="href">bibliography.html#<xsl:value-of select="text()" /></xsl:attribute>
            <xsl:attribute name="class">title-<xsl:value-of select="@level" />-<xsl:value-of select="@type" /></xsl:attribute>
            <xsl:call-template name="propagateattrs" />
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    <xsl:template match="tei:title[@type='main']">
        <xsl:if test="@level='a'">&#x201C;</xsl:if><xsl:element name="span">
            <xsl:attribute name="class">title-<xsl:value-of select="@level" />-<xsl:value-of select="@type" /></xsl:attribute>
            <xsl:call-template name="propagateattrs" />
            <xsl:apply-templates />
        </xsl:element><xsl:if test="@level='a'">&#x201D;</xsl:if>
    </xsl:template>
    <xsl:template match="tei:title">
        <xsl:element name="span">
            <xsl:attribute name="class">title-<xsl:value-of select="@level" />-<xsl:value-of select="@type" /></xsl:attribute>
            <xsl:call-template name="propagateattrs" />
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
