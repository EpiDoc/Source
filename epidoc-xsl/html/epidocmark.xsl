<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template match="tei:mark">
       <xsl:element name="span">
           <xsl:attribute name="class">mark</xsl:attribute>
           <xsl:attribute name="title">mark: <xsl:value-of select="@type"/></xsl:attribute>
           <xsl:call-template name="propagateattrs"/>
             <xsl:text>((</xsl:text>
             <xsl:choose>
               <xsl:when test="contains(@type, 'claudian_')">
                 <xsl:value-of select="substring-after(@type, 'claudian_')"/>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:value-of select="@type"/>
               </xsl:otherwise>
             </xsl:choose>
             <xsl:text>))</xsl:text>
</xsl:element>
    </xsl:template>
</xsl:stylesheet>
