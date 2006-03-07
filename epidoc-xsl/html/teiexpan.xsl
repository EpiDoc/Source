<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- expansion of abbreviation within an epidoc edition div -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="tei:expan[contains(ancestor::tei:div/@type, 'edition')]">
        
        <xsl:element name="span">
            <xsl:attribute name="class">epigraphic-abbreviation-understood</xsl:attribute>
            <xsl:attribute name="title"><xsl:choose><xsl:when test=".//tei:abbr/tei:orig"><xsl:for-each select=".//tei:abbr"><xsl:value-of select="."/></xsl:for-each></xsl:when><xsl:otherwise><xsl:value-of select="."/></xsl:otherwise></xsl:choose></xsl:attribute><xsl:apply-templates/></xsl:element>
    </xsl:template>
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <!-- expansion of abbreviation outside of an epidoc edition div -->
    <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
    <xsl:template match="tei:expan[not(contains(ancestor::tei:div/@type, 'edition'))]">
        
      <xsl:element name="span">
         <xsl:attribute name="class">expansion</xsl:attribute>
         <xsl:attribute name="title"><xsl:value-of select="." /></xsl:attribute>
         <xsl:apply-templates />
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
