<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="writehtmldc">
        <xsl:param name="doctitle"/>
        <xsl:call-template name="writehtmldcprefix"/>
 
        <xsl:comment>Dublin Core metadata</xsl:comment>
        
        <xsl:element name="link" namespace="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="rel">schema.DC</xsl:attribute>
            <xsl:attribute name="href">http://purl.org/dc</xsl:attribute>
        </xsl:element>
        
        <xsl:call-template name="writehtmlmeta">
            <xsl:with-param name="name">DC.title</xsl:with-param>
            <xsl:with-param name="content"><xsl:value-of select="$doctitle"/></xsl:with-param>
        </xsl:call-template>
        
        <xsl:comment>WARNING: the named template writehtmldc does not currently write out all of the appropriate Dublin Core metadata tags</xsl:comment>
        <xsl:call-template name="writehtmldcpostfix"/>
    </xsl:template>
    
    <xsl:template name="writehtmldcprefix"/>
    <xsl:template name="writehtmldcpostfix"/>
</xsl:stylesheet>
