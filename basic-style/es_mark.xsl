<?xml version="1.0" encoding='UTF-8'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:template match="mark">&#x2282;<xsl:element name="i"><xsl:value-of select="@type"/></xsl:element>&#x2283;</xsl:template>
</xsl:stylesheet>
