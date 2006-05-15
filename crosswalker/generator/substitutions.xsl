<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="substitutions">
        <xsl:variable name="varname"><xsl:value-of select="destination"/></xsl:variable>
        <xsl:element name="xsl:choose">
            <xsl:for-each select="substitutions/substitution"> 
                <xsl:element  name="xsl:when">
                    <xsl:attribute name="test">
                        <xsl:choose>
                            <xsl:when test="match">&#x24;<xsl:value-of select="$varname"/> = '<xsl:value-of select="match"/>'</xsl:when>
                            <xsl:when test="partialMatch">contains(&#x24;<xsl:value-of select="$varname"/>, '<xsl:value-of select="match"/>')</xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                    <xsl:value-of select="replace"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
