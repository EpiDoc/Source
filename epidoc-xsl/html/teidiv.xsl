<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:template match="tei:div">
      <xsl:choose>
         <xsl:when test="count(ancestor::*) = 0">
            <xsl:call-template name="dohtmlheadboilerplate" />
            <xsl:call-template name="dohtmlbodyboilerplate" />
         </xsl:when>
         <xsl:otherwise>
            <!-- this div is part of a TEI.2 document or is a subordinate div -->
            <xsl:element name="div">
               <xsl:call-template name="propagateattrs" />
               <xsl:if test="@type">
                  <xsl:attribute name="class">
                     <xsl:value-of select="@type" />
                  </xsl:attribute>
               </xsl:if>
               <xsl:apply-templates />
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
