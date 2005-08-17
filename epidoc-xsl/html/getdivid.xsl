<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="getdivid">
        <xsl:call-template name="getdividprefix"/>

        <xsl:value-of select="generate-id(.)"/>
        
        <xsl:call-template name="getdividpostfix"/>
    </xsl:template>
    
    <xsl:template name="getdividprefix"/>
    <xsl:template name="getdividpostfix"/>
</xsl:stylesheet>
