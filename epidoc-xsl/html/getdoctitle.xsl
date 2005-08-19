<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="getdoctitle">
        <xsl:param name="ascii">false</xsl:param>
        
       
       <!-- get the document title based on the type of root element we're working with -->
       <xsl:variable name="dirtytitle">
       <xsl:choose>
          <xsl:when test="name(/*) = 'TEI.2'"><xsl:value-of select="/tei:TEI.2/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></xsl:when>
          <xsl:when test="name(/*) = 'div'"><xsl:value-of select="/tei:div/tei:head"/></xsl:when>
          <xsl:otherwise>ERROR: the getdoctitle template does not support processing of root elements with the name <xsl:value-of select="name(/*)"/></xsl:otherwise>
       </xsl:choose>
       </xsl:variable>

       <!-- output the result -->
       <xsl:comment>WARNING: the named template getdoctitle does not currently handle the 'ascii' parameter: values returned may include characters beyond base ascii</xsl:comment>
       <xsl:value-of select="normalize-space($dirtytitle)"/>
        
    </xsl:template>
    
</xsl:stylesheet>
