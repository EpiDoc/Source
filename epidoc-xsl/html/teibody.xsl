<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- epidoc-teibody -->
    <!-- 2005-08-10: created by Tom Elliott -->
    
    <xsl:template match="tei:body">
        <xsl:call-template name="teibodyprefix"/>
        
        <xsl:apply-templates/>
        
        <xsl:call-template name="teibodypostfix"/>
    </xsl:template>
    
    <xsl:template name="teibodyprefix"/>
    
    <xsl:template name="teibodypostfix"/>
    
</xsl:stylesheet>
