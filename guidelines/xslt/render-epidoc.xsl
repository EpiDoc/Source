<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml" 
    exclude-result-prefixes="xs tei teix" version="2.0">

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
            <xsl:number count="teix:egXML" level="any" from="tei:div[parent::tei:body]"/>
        </xsl:variable>

        <xsl:variable name="cur-div-id" select="ancestor::tei:div[parent::tei:body]/@xml:id"/>

        <xsl:if test="@rend">
            <div class="rend">
                <p>Transformation using the example EpiDoc P5 stylesheets:</p>
                <ul>
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
                                    <xsl:when test=". = 'petrae'">
                                        <xsl:text>Petrae</xsl:text>
                                    </xsl:when>
                                    <xsl:when test=". = 'iospe'">
                                        <xsl:text>IOSPE</xsl:text>
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
                                    <xsl:when test=". = 'verse'">
                                        <xsl:text>verse parameter on: </xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:if test=". != 'verse'">
                                    <xsl:text> style:</xsl:text>
                                </xsl:if>
                            </strong>
                            <xsl:text> </xsl:text>
                            <xsl:apply-templates select="document(concat('../xml/views/', ., '/examples.xml'))//tei:egXML[@xml:id=concat($cur-div-id,'#',$cur-num)]/node()"
                                mode="epidoc-force-html-namespace" />
                         </li>
                    </xsl:for-each>
                </ul>
            </div>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="node()" mode="epidoc-force-html-namespace">
        <xsl:choose>
            <xsl:when test="self::element()">
                <xsl:element name="{local-name()}"
                    namespace="http://www.w3.org/1999/xhtml">
                    <xsl:copy-of select="@*" />
                    <xsl:apply-templates mode="epidoc-force-html-namespace"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="self::text()">
                <xsl:variable name="normed-value" select="normalize-space(.)"/>
                <xsl:choose>
                    <xsl:when test="$normed-value=' '">
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:when test="string-length($normed-value)=0">
                        <xsl:text> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="substring(., 1, 1)=' ' and preceding-sibling::node()[1]/self::element()">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="$normed-value"/>
                        <xsl:if test="substring(., string-length(.), 1)=' ' and following-sibling::node()[1]/self::element()">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    

</xsl:stylesheet>
