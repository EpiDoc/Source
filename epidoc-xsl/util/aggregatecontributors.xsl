<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <xsl:element name="div">
        <xsl:copy-of select="//tei:titleStmt/tei:title" />
        <xsl:for-each select="//tei:respStmt[tei:resp = 'author']">
            <xsl:sort select="tei:name" />
            <xsl:variable name="thisname"><xsl:value-of select="tei:name"/></xsl:variable>
            <xsl:variable name="forename"><xsl:value-of select="substring-before(tei:name, ' ')"/></xsl:variable>
            <xsl:variable name="surname"><xsl:value-of select="substring-after(tei:name, ' ')"/></xsl:variable>
            <xsl:if test="not(preceding::tei:name[text()=$thisname and ../tei:resp='author'])">
                <xsl:element name="author">
                    <xsl:element name="surname"><xsl:value-of select="$surname"/></xsl:element>
                    <xsl:element name="forename"><xsl:value-of select="$forename"/></xsl:element>
                    <xsl:element name="persName"><xsl:value-of select="$thisname"/></xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="//tei:respStmt[tei:resp != 'author']">
            <xsl:sort select="tei:name" />
            <xsl:variable name="thisname"><xsl:value-of select="tei:name"/></xsl:variable>
            <xsl:variable name="forename"><xsl:value-of select="substring-before(tei:name, ' ')"/></xsl:variable>
            <xsl:variable name="surname"><xsl:value-of select="substring-after(tei:name, ' ')"/></xsl:variable>
            <xsl:if test="not(preceding::tei:name[text()=$thisname]) and not(//tei:respStmt[tei:resp/text()='author' and tei:name/text()=$thisname])">
                <xsl:element name="respStmt">
                    <xsl:element name="resp">contributor</xsl:element>
                <xsl:element name="name">
                    <xsl:element name="surname"><xsl:value-of select="$surname"/></xsl:element>
                    <xsl:element name="forename"><xsl:value-of select="$forename"/></xsl:element>
                    <xsl:element name="persName"><xsl:value-of select="$thisname"/></xsl:element>
                </xsl:element></xsl:element>
            </xsl:if>
        </xsl:for-each>            
            </xsl:element>
    </xsl:template>
    <xsl:template match="tei:title[../tei:titleStmt]">
        <xsl:copy-of select="tei:title" />
    </xsl:template>
</xsl:stylesheet>
