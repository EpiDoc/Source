<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template match="tei:hi"> 
      <xsl:choose>
         <xsl:when test="@rend='italic'">
            <xsl:element name="span">
               <xsl:attribute name="class">italic</xsl:attribute>
               <xsl:apply-templates />
            </xsl:element>
         </xsl:when>
         <xsl:when test="@rend='strong'">
            <xsl:element name="strong">
               <xsl:apply-templates />
            </xsl:element>
         </xsl:when>
          <xsl:when test="@rend='underline'">
              <xsl:element name="span">
                  <xsl:attribute name="class">underline</xsl:attribute>
                  <xsl:apply-templates />
              </xsl:element>
          </xsl:when>
         <xsl:otherwise>
            <xsl:comment>hi tag with rend=<xsl:value-of select="@rend" /> is not supported!</xsl:comment>
            <xsl:element name="span">
               <xsl:attribute name="class">error</xsl:attribute>
               <xsl:attribute name="title">hi tag with rend=<xsl:value-of select="@rend" /> is not supported!</xsl:attribute>
               <xsl:apply-templates />
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
