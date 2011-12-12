<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei teix" version="2.0">
        
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 16, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> tom</xd:p>
            <xd:p><xd:b>Author:</xd:b> raffaele</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template name="render-epidoc">
        <xsl:variable name="cur-num">
            <xsl:number count="teix:egXML" from="tei:div"></xsl:number>
        </xsl:variable>
        
        <xsl:variable name="cur-div-id" select="parent::tei:div/@xml:id"/>
        
        <p>Transformation using the example EpiDoc P5 stylesheets:</p>
        <ul>
            <xsl:choose>
                <xsl:when test="not(@rend)">
                    <li><strong>Default style:</strong> 
                    <!-- get current egXML from panciera view -->
                        <xsl:copy-of select="document('../xml/views/panciera/examples.xml')//tei:egXML[@xml:id=concat($cur-div-id,'#',$cur-num)]"/>
                    </li>
                </xsl:when>
                <xsl:otherwise>                    
                    <xsl:for-each select="tokenize(@rend, ' ')">
                        <!-- here's where I'd like to specify the leiden style, based on the current token value from @rend, before processing the children -->
                        <li><strong><xsl:value-of select="."/> style:</strong> 
                            <xsl:copy-of select="document(concat('../xml/views/', ., '/examples.xml'))//tei:egXML[@xml:id=concat($cur-div-id,'#',$cur-num)]"/>
                        </li>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose></ul>
    </xsl:template>
        
    
</xsl:stylesheet>
