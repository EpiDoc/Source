<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template match="tei:gap[@reason='illegible' and @unit='character']">
      <xsl:element name="span">
         <xsl:attribute name="class">gap-illegible</xsl:attribute>
         <xsl:attribute name="title"><xsl:value-of select="@extent"/> illegible character<xsl:if test="@extent &gt; 1">s</xsl:if></xsl:attribute>
         <xsl:call-template name="propagateattrs"/>
         <xsl:attribute name="lang"><xsl:value-of select="ancestor::*[@lang]/@lang"/></xsl:attribute>
         <xsl:attribute name="xml:lang"><xsl:value-of select="ancestor::*[@lang]/@lang"/></xsl:attribute>
         <xsl:choose>
            <xsl:when test="@extent &lt; 4"><xsl:call-template name="repeatstring"><xsl:with-param name="rstring" select="$vestigemark"/><xsl:with-param name="rcount" select="@extent"/></xsl:call-template></xsl:when>
      <xsl:otherwise><xsl:value-of select="$vestigemark"/><xsl:text> </xsl:text><xsl:value-of select="@extent"/><xsl:text> </xsl:text><xsl:value-of select="$vestigemark"/></xsl:otherwise>
         </xsl:choose></xsl:element>
         
   </xsl:template>
   
   <xsl:template name="repeatstring">
      <xsl:param name="rstring"/>
      <xsl:param name="rcount"/>
      <xsl:if test="$rcount &gt; 0"
         ><xsl:value-of select="$rstring"
            /><xsl:call-template name="repeatstring"
            ><xsl:with-param name="rstring"  select="$rstring"
            /><xsl:with-param name="rcount" select="$rcount - 1"/></xsl:call-template
         ></xsl:if>
   </xsl:template>
</xsl:stylesheet>
