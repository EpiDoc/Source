<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xml="http://www.w3.org/XML/1998/namespace"
    xmlns:xi="http://www.w3.org/2001/XInclude">

    <xsl:template match="/tei:TEI.2">
        <xsl:element name="div">
            <xsl:attribute name="xmlns">http://www.tei-c.org/ns/1.0</xsl:attribute>
            <xsl:attribute name="xmlns:tei">http://www.tei-c.org/ns/1.0</xsl:attribute>
            <!-- <xsl:attribute name="xmlns:xi">http://www.w3.org/2001/XInclude</xsl:attribute> -->
            
                <xsl:element name="list">
                    <xsl:attribute name="type">exempla</xsl:attribute>
                    <xsl:for-each select="//tei:item[ancestor::tei:div/@type='gl-edition']">
                        <xsl:for-each select="descendant::*">
                            <xsl:element name="item">
                                <xsl:attribute name="type">exemplum</xsl:attribute>
                                <xsl:element name="seg">
                                    <xsl:attribute name="type">tagi</xsl:attribute>
                                    <xsl:value-of select="name()"/>
                                </xsl:element>
                                <xsl:element name="xref">
                                    <xsl:attribute name="href"><xsl:value-of select="ancestor::tei:div[@type='gl-edition']/ancestor::tei:div[not(@type) and @id][1]/@id"/>.xml</xsl:attribute><xsl:value-of select="ancestor::tei:div[@type='gl-edition']/ancestor::tei:div[not(@type) and @id][1]/tei:head"/></xsl:element>
                                <xsl:element name="list">
                                    <xsl:attribute name="type">eg</xsl:attribute>
                                    <xsl:copy-of select="ancestor::tei:item"/>
                                </xsl:element>
                            </xsl:element>
                            
                            </xsl:for-each>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
      
    </xsl:template>
</xsl:stylesheet>
