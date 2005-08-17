<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="getdoctitle">
        <xsl:param name="ascii">false</xsl:param>
        <xsl:call-template name="getdoctitleprefix"/>
        
        <xsl:comment>WARNING: the named template getdoctitle does not currently handle the 'ascii' parameter: values returned may include characters beyond base ascii</xsl:comment>
        <xsl:choose>
            <xsl:when test="ascii"><xsl:value-of select="/tei:TEI.2/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="/tei:TEI.2/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></xsl:otherwise>
        </xsl:choose>
        
        <xsl:call-template name="getdoctitlepostfix"/>
    </xsl:template>
    
    <xsl:template name="getdoctitleprefix"/>
    <xsl:template name="getdoctitlepostfix"/>
</xsl:stylesheet>
