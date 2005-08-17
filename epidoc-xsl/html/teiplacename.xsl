<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:template match="tei:placeName">
      <xsl:choose>
         <xsl:when test="@key">
            <xsl:element name="a">
               <xsl:attribute name="class">place-name</xsl:attribute>
               <xsl:call-template name="propagateattrs" />
               <xsl:if test="@reg">
                  <xsl:attribute name="title">
                     <xsl:value-of select="@reg" />
                  </xsl:attribute>
               </xsl:if>
               <xsl:attribute name="href"><xsl:value-of select="$placenameuriprefix" />#<xsl:value-of select="@key" /></xsl:attribute>
               <xsl:apply-templates />
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="span">
               <xsl:attribute name="class">personal-name</xsl:attribute>
               <xsl:call-template name="propagateattrs" />
               <xsl:if test="@reg">
                  <xsl:attribute name="title">
                     <xsl:value-of select="@reg" />
                  </xsl:attribute>
               </xsl:if>
               <xsl:apply-templates />
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
