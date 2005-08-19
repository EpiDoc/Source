<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template name="dohtmlbodyboilerplate">
      <xsl:element name="body">
         <!-- create an html div to function as the header -->
         <xsl:element name="div">
            <xsl:attribute name="id">
               <xsl:value-of select="$htmlheaderdivid" />
            </xsl:attribute>
            <xsl:element name="h1">
               <xsl:call-template name="getdoctitle" />
            </xsl:element>
         </xsl:element>
         <!-- create an html div to function as a separator/navigation bar -->
         <xsl:element name="div">
            <xsl:attribute name="id"><xsl:value-of select="$htmlseparatordivid" /></xsl:attribute>
            <xsl:element name="p">
               <xsl:attribute name="class">abstract</xsl:attribute>
               <xsl:if test="/*/@id">id: <xsl:value-of select="/*/@id" /> |<xsl:text> </xsl:text></xsl:if>
               <xsl:if test="/*/@n">n: <xsl:value-of select="/*/@n" /> |<xsl:text> </xsl:text></xsl:if>
               <xsl:for-each select="/*//tei:div">
                  <xsl:if test="not(ancestor-or-self::tei:div[substring-after(@id, '-') = 'subsections'])">
                  <xsl:element name="a">
                     <xsl:attribute name="class">htmlnavigation</xsl:attribute>
                     <xsl:attribute name="href">#<xsl:call-template name="getdivid" /></xsl:attribute>
                     <xsl:call-template name="lowercase">
                        <xsl:with-param name="victimstring" select="tei:head" />
                     </xsl:call-template>
                  </xsl:element>
                  <xsl:if test="count(following::tei:div) != 0">
                     <xsl:text> | </xsl:text>
                  </xsl:if>
                  </xsl:if>
               </xsl:for-each>
            </xsl:element>
         </xsl:element>
         <!-- handle any teiHeader metadata -->
         <xsl:call-template name="doteiheadermetadata" />
         <!-- create an html div to contain the rest of the document content -->
         <xsl:element name="div">
            <xsl:attribute name="id">
               <xsl:value-of select="$htmlcontentdivid" />
            </xsl:attribute>
            <xsl:apply-templates />
         </xsl:element>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
