<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="writehtmlmeta">
        <xsl:param name="name"/>
        <xsl:param name="content"/>
        <xsl:call-template name="writehtmlmetaprefix"/>
        
        <xsl:if test="string-length($name) &gt; 0 and string-length($content) &gt; 0">
            <xsl:element name="meta">
                <xsl:attribute name="name"><xsl:value-of select="$name"/></xsl:attribute>
                <xsl:attribute name="content"><xsl:value-of select="$content"/></xsl:attribute>
            </xsl:element>
        </xsl:if>
        
        <xsl:call-template name="writehtmlmetapostfix"/>
    </xsl:template>
    
    <xsl:template name="writehtmlmetaprefix"/>
    <xsl:template name="writehtmlmetapostfix"/>
</xsl:stylesheet>
