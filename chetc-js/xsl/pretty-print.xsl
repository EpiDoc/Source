<?xml version="1.0" encoding="UTF-8" ?>
<!--
	pretty-print
	Created by Hugh Cayless on 2006-03-04.
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output encoding="UTF-8" indent="yes" method="xml" />

	<xsl:template match="/">
		<div>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="*">
		&lt;<xsl:value-of select="name(.)"/><xsl:for-each select="./@*"> <xsl:value-of select="name(.)"/>="<xsl:value-of select="."/>"</xsl:for-each>&gt;
			<xsl:apply-templates select="text()|*"/>
		&lt;/<xsl:value-of select="name(.)"/>&gt;
	</xsl:template>
	
	<xsl:template match="text()">
		<xsl:value-of select="."/>
	</xsl:template>
	
</xsl:stylesheet>
