<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs tei" version="2.0">
    
    <xsl:import href="../../example-p5-xslt/start-edition.xsl"/>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    
    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> June 8, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> raffaele</xd:p>
            <xd:p></xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:variable name="context">
        <xsl:apply-templates mode="identity_change"/>
    </xsl:variable>
    
    <xsl:template match="/">
        <egXMLs xmlns="http://www.tei-c.org/ns/1.0">
            <xsl:apply-templates select="$context//tei:egXML">
                <xsl:with-param name="parm-edition-type" select="$edition-type" tunnel="yes"/>
                <xsl:with-param name="parm-leiden-style" select="$leiden-style" tunnel="yes"/>
            </xsl:apply-templates>
        </egXMLs>
    </xsl:template>
    
    <xsl:template match="tei:egXML">
        <xsl:variable name="num">
            <xsl:number count="tei:egXML" level="any" from="tei:div[parent::tei:body]"/>
        </xsl:variable>
        <egXML xmlns="http://www.tei-c.org/ns/1.0" xml:id="{concat(ancestor::tei:div[parent::tei:body]/@xml:id,'#', $num)}">
            <xsl:apply-templates />
        </egXML>
    </xsl:template>
    
    <xsl:template match="text()" mode="identity_change">        
        <xsl:sequence select="."/>
    </xsl:template>
    
    <xsl:template match="*" mode="identity_change">
        <xsl:element name="{local-name()}" namespace="http://www.tei-c.org/ns/1.0">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="* | text()" mode="identity_change"/>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
