<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="hyphen">
    <xsl:choose>
        <xsl:when test="not(ancestor::brackets) and not(ancestor::parentheses)">
            <xsl:if test="name(preceding-sibling::node()[1])!='hyphen'"><gap reason="lost" extent="?" unit="line"/></xsl:if>
        </xsl:when>
        <xsl:when test="ancestor::parentheses">-</xsl:when>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
