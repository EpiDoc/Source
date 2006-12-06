<?xml version="1.0" encoding="UTF-8"?>
<!-- 	Created by Hugh Cayless during the Epidoc Chapel Hill sprint (2006-12-2 to 2006-12-6).
		This stylesheet takes a source document with inscription data organized into key-value pairs
		and outputs an EpiDoc document based on a template file for each inscription in the source. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:exsl="http://exslt.org/common"
	xmlns:dyn="http://exslt.org/dynamic"
	extension-element-prefixes="exsl dyn"
	version="1.0" 
	exclude-result-prefixes="exsl dyn">

	<xsl:template match="/inscriptiones">
		<xsl:apply-templates select="inscriptio"/>
	</xsl:template>
	
	<xsl:template match="inscriptio">
		<xsl:variable name="insc_path" select="."/>
		<exsl:document href="{normalize-space(filename)}.xml" doctype-system="../../../dtd/tei-epidoc.dtd">
			<xsl:apply-templates select="document('edrkv2epidoc.xml')"><xsl:with-param name="root" select="$insc_path"/></xsl:apply-templates>
		</exsl:document>
	</xsl:template>
	
	<xsl:template match="*[starts-with(xptr/@from, '#')]">
		<xsl:param name="root"/>
		<xsl:variable name="current" select="."/>
		<xsl:apply-templates select="$root" mode="lookup-xptr">
			<xsl:with-param name="current" select="$current"/>
			<xsl:with-param name="path" select="substring-after(xptr/@from, '#')"/>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- 	In order to facilitate the generation of multiple copies of elements in the template
			corresponding to multiple values in the source, we need to switch source trees. -->
	<xsl:template match="*" mode="lookup-xptr">
		<xsl:param name="current"/>
		<xsl:param name="path"/>
		<xsl:variable name="root" select="."/>
		<xsl:for-each select="dyn:evaluate($path)">
			<xsl:variable name="key" select="dyn:evaluate(substring-after($current/@key, '#'))"/>
			<xsl:element name="{local-name($current)}">
				<xsl:copy-of select="$current/@*[not(starts-with(., '#'))]"/>
				<xsl:if test="$key">
					<xsl:attribute name="key"><xsl:value-of select="$key"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="ancestor::*[@cert = 'low']">
					<xsl:copy-of select="ancestor::*[@cert]/@cert"/>
				</xsl:if>
				<xsl:copy-of select="./node()"/>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="@*|node()">
		<xsl:param name="root"/>
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"><xsl:with-param name="root" select="$root"/></xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
