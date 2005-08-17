<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="getdoctitle">
        <xsl:param name="ascii">false</xsl:param>
        <xsl:choose>
            <xsl:when test="ascii">
                
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="/tei:TEI.2/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
