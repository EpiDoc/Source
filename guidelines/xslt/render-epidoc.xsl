<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei teix" version="2.0">

    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 16, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> tom</xd:p>
            <xd:p><xd:b>Author:</xd:b> raffaele</xd:p>
            <xd:p><xd:b>Author:</xd:b> gabrielbodard</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>

    <xsl:template name="render-epidoc">
        <xsl:variable name="cur-num">
            <xsl:number count="teix:egXML" from="tei:div"/>
        </xsl:variable>

        <xsl:variable name="cur-div-id" select="parent::tei:div/@xml:id"/>

        <xsl:if test="@rend">
            <p>Transformation using the example EpiDoc P5 stylesheets:</p>
            <ul>
                <!--<li><strong>Default style (Panciera):</strong> 
                    <!-\- get current egXML from panciera view -\->
                        <xsl:copy-of select="document('../xml/views/panciera/examples.xml')//tei:egXML[@xml:id=concat($cur-div-id,'#',$cur-num)]"/>
                    </li>-->

                <xsl:for-each select="tokenize(@rend, ' ')">
                    <li>
                        <strong>
                            <xsl:choose>
                                <xsl:when test=". = 'panciera'">
                                    <xsl:text>Default (Panciera)</xsl:text>
                                </xsl:when>
                                <xsl:when test=". = 'ddbdp'">
                                    <xsl:text>Duke Databank</xsl:text>
                                </xsl:when>
                                <xsl:when test=". = 'dohnicht'">
                                    <xsl:text>Dohnicht</xsl:text>
                                </xsl:when>
                                <xsl:when test=". =('edh','edh-web')">
                                    <xsl:text>EDH</xsl:text>
                                </xsl:when>
                                <xsl:when test=". = 'london'">
                                    <xsl:text>London</xsl:text>
                                </xsl:when>
                                <xsl:when test=". = 'rib'">
                                    <xsl:text>RIB</xsl:text>
                                </xsl:when>
                                <xsl:when test=". = 'seg'">
                                    <xsl:text>SEG</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="."/>
                                </xsl:otherwise>
                            </xsl:choose>
                          <xsl:text> style:</xsl:text>
                        </strong>
                        <xsl:copy-of
                            select="document(concat('../xml/views/', ., '/examples.xml'))//tei:egXML[@xml:id=concat($cur-div-id,'#',$cur-num)]"
                        />
                    </li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>


</xsl:stylesheet>
