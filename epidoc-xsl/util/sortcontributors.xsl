<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/tei:div">
        <xsl:copy>
            <xsl:apply-templates select="tei:title"/>
            <xsl:apply-templates select="tei:author">
                <xsl:sort select="tei:surname"/>
                <xsl:sort select="tei:forename"/>
            </xsl:apply-templates>
            <xsl:for-each select="tei:respStmt">
                <xsl:sort select="tei:name/tei:surname"/>
                <xsl:sort select="tei:name/tei:forename"/>
                <xsl:copy>
                    <xsl:element name="resp">contributor</xsl:element>
                    <xsl:element name="name"><xsl:value-of select="tei:name/tei:persName"/></xsl:element>
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:title"><xsl:copy-of select="."/></xsl:template>
    <xsl:template match="tei:author">
        <xsl:copy>
            <xsl:value-of select="tei:persName"/>
        </xsl:copy>
        </xsl:template>
</xsl:stylesheet>
