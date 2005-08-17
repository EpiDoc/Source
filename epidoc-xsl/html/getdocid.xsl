<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="getdocid">
        <xsl:call-template name="getdocidprefix"/>
        
        <xsl:value-of select="/tei:TEI.2/@id"/>
        
        <xsl:call-template name="getdocidpostfix"/>
    </xsl:template>
    
    <xsl:template name="getdocidprefix"/>
    <xsl:template name="getdocidpostfix"/>
</xsl:stylesheet>
