<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="tei:div">
        <xsl:choose>
            <xsl:when test="name(..) = 'body' and count(preceding-sibling::tei:div) = 0">
                <xsl:element name="ul">
                    <xsl:for-each select="../tei:div[@id]"><xsl:call-template name="multipartpopdown"/></xsl:for-each>
                </xsl:element>
            </xsl:when>
            <xsl:when test="name(..) = 'body' and count(preceding-sibling::tei:div) &gt; 0"/>
            <xsl:when test="@id and not(contains(ancestor-or-self::tei:div/@type, 'gl-'))">
                <xsl:call-template name="multipartpopdown"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
