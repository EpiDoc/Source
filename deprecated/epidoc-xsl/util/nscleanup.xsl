<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    xmlns:xml="http://www.w3.org/XML/1998/namespace">

    <xsl:template match="/"><xsl:apply-templates/></xsl:template>
    
    <xsl:template match="xhtml:*">
        <xsl:element name="{local-name()}" namespace="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*[namespace-uri()='http://www.w3.org/XML/1998/namespace']">
        <xsl:attribute name="xml:{local-name()}" namespace="http://www.w3.org/XML/1998/namespace"><xsl:value-of select="."/></xsl:attribute>
    </xsl:template>
    <xsl:template match="@*"><xsl:copy-of select="."/></xsl:template>
    
    
</xsl:stylesheet>
