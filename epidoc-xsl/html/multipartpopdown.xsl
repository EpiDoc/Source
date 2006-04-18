<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template name="multipartpopdown">
        <xsl:element name="li">
            <xsl:element name="a">
                <xsl:attribute name="href"><xsl:value-of select="@id"/>.html</xsl:attribute><xsl:value-of select="tei:head" /></xsl:element>
            <xsl:choose>
                <xsl:when test="./@rend='multipart' and count(tei:div[not(contains(./@type, 'gl-'))]) &gt; 0">
                    <xsl:element name="ul">
                        <xsl:apply-templates select="tei:div" />
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise />
            </xsl:choose>
        </xsl:element>        
    </xsl:template>
    
</xsl:stylesheet>
