<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="tei:div" mode="epidoc-edition">
        <xsl:call-template name="diveditionprefix"/>
        
        <xsl:attribute name="class">epidoc-edition</xsl:attribute>
        <xsl:apply-templates mode="epidoc-edition"/>
        
        <xsl:call-template name="diveditionpostfix"/>
    </xsl:template>    
    <xsl:template name="diveditionprefix"/>
    <xsl:template name="diveditionpostfix"/>
</xsl:stylesheet>
