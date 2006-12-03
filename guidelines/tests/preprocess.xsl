<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="1.0">
    
    <xsl:output indent="yes"/>
    
    <xsl:template match="/">
        <div>
            <xsl:apply-templates select="//tei:div[@type='gl-typographic']"/>
        	<xsl:apply-templates select="//tei:div[@type='gl-regextest']"/>
        	<xsl:apply-templates select="//tei:div[@type='gl-edition']" mode="process-edition"/>
        </div>
    </xsl:template>
    
	<xsl:template match="tei:div[@type='gl-edition']" mode="process-edition">
        <xsl:copy><xsl:apply-templates/></xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*|text()|*[local-name(.) != 'item' and local-name(.) != 'link']">
        <xsl:copy><xsl:apply-templates/></xsl:copy>
    </xsl:template>
    
	<xsl:template match="tei:link[@type = 'regextest']">
        <link type="regextest" xml:id="{@id}">
            <target><xsl:attribute name="type"><xsl:value-of select="substring-before(substring-before(@targets, ' '), '-')"></xsl:value-of></xsl:attribute><xsl:value-of select="substring-before(@targets, ' ')"/></target>
        	<target><xsl:attribute name="type"><xsl:value-of select="substring-before(substring-before(substring-after(@targets, ' '), ' '), '-')"></xsl:value-of></xsl:attribute><xsl:value-of select="substring-before(substring-after(@targets, ' '), ' ')"/></target>
        	<target><xsl:attribute name="type"><xsl:value-of select="substring-before(substring-after(substring-after(@targets, ' '), ' '), '-')"></xsl:value-of></xsl:attribute><xsl:value-of select="substring-after(substring-after(@targets, ' '), ' ')"/></target>
        </link>
    </xsl:template>
    
	<xsl:template match="tei:item">
        <item xml:id="{@id}"><xsl:apply-templates mode="process-item-children"/></item></xsl:template>
    
    <xsl:template match="note" mode="process-item-children"/>
    
	<xsl:template match="*[ancestor::tei:item]" mode="process-item-children" xml:space="preserve">&lt;<xsl:value-of select="local-name(.)"/><xsl:for-each select="@*"> <xsl:value-of select="local-name(.)"/>="<xsl:value-of select="."/>"</xsl:for-each><xsl:choose>
		<xsl:when test="./node()">&gt;<xsl:apply-templates/>&lt;/<xsl:value-of select="local-name(.)"/>&gt;</xsl:when>
		<xsl:otherwise>/&gt;</xsl:otherwise>
	</xsl:choose>
		</xsl:template>
    
</xsl:stylesheet>
