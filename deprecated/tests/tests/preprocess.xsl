<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">
    
    <xsl:output indent="yes"/>
    
    <xsl:template match="/">
        <div>
            <xsl:apply-templates select="//div[@type='gl-typographic']"/>
            <xsl:apply-templates select="//div[@type='gl-regextest']"/>
            <xsl:apply-templates select="//div[@type='gl-edition']" mode="process-edition"/>
        </div>
    </xsl:template>
    
    <xsl:template match="div[@type='gl-edition']" mode="process-edition">
        <xsl:copy><xsl:apply-templates/></xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*|text()|*[local-name(.) != 'item' and local-name(.) != 'link']">
        <xsl:copy><xsl:apply-templates/></xsl:copy>
    </xsl:template>
    
    <xsl:template match="link[@type = 'regextest']">
        <link type="regextest" xml:id="{@id}">
            <xsl:for-each select="fn:tokenize(@targets, '\s')">
                <target><xsl:attribute name="type"><xsl:value-of select="substring-before(., '-')"></xsl:value-of></xsl:attribute><xsl:value-of select="."/></target>
            </xsl:for-each>
        </link>
    </xsl:template>
    
    <xsl:template match="item">
        <item xml:id="{@id}"><xsl:apply-templates mode="process-item-children"/></item></xsl:template>
    
    <xsl:template match="note" mode="process-item-children"/>
    
    <xsl:template match="*[ancestor::item]" mode="process-item-children">&lt;<xsl:value-of select="local-name(.)"/><xsl:for-each select="@*"> <xsl:value-of select="local-name(.)"/>="<xsl:value-of select="."/>"</xsl:for-each>&gt;<xsl:apply-templates/>&lt;/<xsl:value-of select="local-name(.)"/>&gt;</xsl:template>
    
</xsl:stylesheet>
