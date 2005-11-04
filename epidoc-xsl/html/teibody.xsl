<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- epidoc-teibody -->
    <!-- 2005-08-10: created by Tom Elliott -->
    
    <xsl:template match="tei:body">
        <xsl:call-template name="teibodyprefix"/>
        
        <xsl:choose>
            <xsl:when test="ancestor::tei:TEI.2/@rend='multipart'">
                <xsl:apply-templates select="*[not(tei:div)]"/>
                <xsl:element name="h2">Subsections:</xsl:element>
                <xsl:element name="ul">
                    <xsl:apply-templates select="tei:div"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
        </xsl:choose>
        
        <xsl:call-template name="teibodypostfix"/>
    </xsl:template>
    
    <xsl:template name="teibodyprefix"/>
    
    <xsl:template name="teibodypostfix"/>
    
</xsl:stylesheet>
