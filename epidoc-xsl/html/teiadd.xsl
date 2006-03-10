<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
    <xsl:template match="tei:add[contains(ancestor::tei:div/@type, 'edition')]">
        <xsl:element name="span">
            <xsl:attribute name="class">addition</xsl:attribute>
            <xsl:attribute name="title"><xsl:if test="@place"><xsl:value-of select="@place"/> </xsl:if> addition in antiquity</xsl:attribute>`<xsl:apply-templates/>´</xsl:element>
    </xsl:template>
    <xsl:template match="tei:add[not(contains(ancestor::tei:div/@type, 'edition'))]">
        <xsl:element name="span">
            <xsl:attribute name="class">add-not-in-edition</xsl:attribute><xsl:apply-templates/></xsl:element>
    </xsl:template>
</xsl:stylesheet>
