<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <!-- epidoc-teiheader -->
   <!-- 2005-08-10: created by Tom Elliott -->
   <xsl:template match="tei:teiHeader">
      <xsl:element name="head">
         <xsl:call-template name="teiheaderprefix" />
         <xsl:variable name="doctitle">
            <xsl:call-template name="getdoctitle">
               <xsl:with-param name="ascii">true</xsl:with-param>
            </xsl:call-template>
         </xsl:variable>
         <xsl:comment>standard html content type information</xsl:comment>
         <xsl:element name="meta" namespace="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="http-equiv">content-type</xsl:attribute>
            <xsl:attribute name="content">application/xhtml+xml; charset=utf-8</xsl:attribute>
         </xsl:element>
         <xsl:call-template name="writehtmldc">
            <xsl:with-param name="doctitle" select="$doctitle" />
         </xsl:call-template>
         <!-- <xsl:apply-templates/> -->
         <xsl:comment>NOTICE: the template with match=teiHeader does not call apply-templates</xsl:comment>
         <xsl:comment>link to bookmark icon</xsl:comment>
         <xsl:element name="link">
            <xsl:attribute name="rel">shortcut icon</xsl:attribute>
            <xsl:attribute name="href">
               <xsl:value-of select="$faviconpath" />
            </xsl:attribute>
         </xsl:element>
         <xsl:comment>standard html title for this document</xsl:comment>
         <xsl:element name="title">
            <xsl:value-of select="$doctitle" />
         </xsl:element>
         <xsl:comment>cascading stylesheets</xsl:comment>
         <xsl:element name="style">
            <xsl:attribute name="type">text/css</xsl:attribute>
            <xsl:attribute name="media">screen</xsl:attribute>
            <xsl:text> </xsl:text>@import "<xsl:value-of select="$screencsspath" />";<xsl:text> </xsl:text>
         </xsl:element>
         <xsl:element name="style">
            <xsl:attribute name="type">text/css</xsl:attribute>
            <xsl:attribute name="media">print</xsl:attribute>
            <xsl:text> </xsl:text>@import "<xsl:value-of select="$printcsspath" />";<xsl:text> </xsl:text>
         </xsl:element>
         <xsl:call-template name="teiheaderpostfix" />
      </xsl:element>
   </xsl:template>
   <xsl:template name="teiheaderprefix" />
   <xsl:template name="teiheaderpostfix" />
</xsl:stylesheet>
