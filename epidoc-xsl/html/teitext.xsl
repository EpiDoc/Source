<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <!-- epidoc-teitext -->
   <!-- 2005-08-10: created by Tom Elliott -->
   <xsl:template match="tei:text">
      <xsl:element name="body">
         <xsl:call-template name="teitextprefix" />
         <xsl:element name="div">
            <xsl:attribute name="id">
               <xsl:value-of select="$htmlheaderdivid" />
            </xsl:attribute>
            <xsl:element name="h1">
               <xsl:call-template name="getdoctitle" />
            </xsl:element>
         </xsl:element>
         <xsl:element name="div">
            <xsl:attribute name="id">
               <xsl:value-of select="$htmlseparatordivid" />
            </xsl:attribute>
            <xsl:element name="p">
               <xsl:attribute name="class">abstract</xsl:attribute>
               <xsl:if test="/tei:TEI.2/@id">id: <xsl:value-of select="/tei:TEI.2/@id" /> |<xsl:text> </xsl:text></xsl:if>
               <xsl:if test="/tei:TEI.2/@n">n: <xsl:value-of select="/tei:TEI.2/@n" /> |<xsl:text> </xsl:text></xsl:if>
               <xsl:for-each select="//tei:text/tei:body/tei:div">
                  <xsl:element name="a">
                     <xsl:attribute name="class">htmlnavigation</xsl:attribute>
                     <xsl:attribute name="href">#<xsl:call-template name="getid" /></xsl:attribute>
                     <xsl:call-template name="lowercase">
                        <xsl:with-param name="victimstring" select="tei:head" />
                     </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="generate-id(.) != generate-id(//tei:text/tei:body/tei:div[last()])">
                     <xsl:text> | </xsl:text>
                  </xsl:if>
               </xsl:for-each>
            </xsl:element>
         </xsl:element>
         <xsl:element name="div">
            <xsl:attribute name="id">
               <xsl:value-of select="$htmlcontentdivid" />
            </xsl:attribute>
            <xsl:apply-templates />
         </xsl:element>
         <xsl:call-template name="doteiheadermetadata"/>
         <xsl:call-template name="teitextpostfix" />
      </xsl:element>
   </xsl:template>
   <xsl:template name="teitextprefix" />
   <xsl:template name="teitextpostfix" />
</xsl:stylesheet>
