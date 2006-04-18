<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="tei:lb">
        <xsl:call-template name="teilbprefix"/>
        <xsl:if test="@type='worddiv'">-</xsl:if>
        <xsl:if test="preceding::tei:lb[1][@rend='right-to-left']"> &#x2190;</xsl:if>
        <xsl:if test="preceding::tei:lb[1][@rend='left-to-right']"> &#x2192;</xsl:if>
        <xsl:text>
            </xsl:text><xsl:element name="br">
                <xsl:call-template name="propagateattrs"/>
                <xsl:apply-templates/>
            </xsl:element>
        <xsl:call-template name="dolinenumbering"/>
        <!-- do not move next line: customization stub -->
            <xsl:call-template name="teilbpostfix"/>
    </xsl:template>
    
    <xsl:template match="tei:lb" mode="epidoc-edition"><xsl:apply-templates select="."/></xsl:template>
    
    <xsl:template name="teilbprefix"/>
    <xsl:template name="teilbpostfix"/>
</xsl:stylesheet>
