<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <xsl:import href="xsl-epidoc-eg/htm-imports.xsl"/>
    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 16, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> tom</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template name="render-epidoc">
        <xsl:variable name="context" select="."/>
        <p>Transformation using the example EpiDoc P5 stylesheets:</p>
        <ul>
            <xsl:choose>
                <xsl:when test="not(@rend)">
                    <li><strong>Panciera:</strong> <xsl:apply-templates/></li>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="tokenize(@rend, ' ')">
                        <xsl:message>token: <xsl:value-of select="."/></xsl:message>
                        <!-- here's where I'd like to specify the leiden style, based on the current token value from @rend, before processing the children -->
                        <xsl:apply-templates select="$context/node()"/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose></ul>
    </xsl:template>
    
    
</xsl:stylesheet>
