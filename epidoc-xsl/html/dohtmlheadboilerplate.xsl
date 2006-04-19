<?xml version="1.0" encoding="UTF-8"?>
 
 <!-- Start license statement: do not remove 
 
 EpiDoc Standard Stylesheets
 Copyright (C) 2000-2006 by all contributors
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 
 Information about the EpiDoc community can be obtained via
  http://epidoc.sf.net.
 
 End license statement: do not remove -->
 

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <xsl:template name="dohtmlheadboilerplate">
       <xsl:param name="doctitleprefix"></xsl:param>
       
      <xsl:element name="head">
         <!-- get the document title -->
         <xsl:variable name="doctitle"><xsl:value-of select="$doctitleprefix"/><xsl:call-template name="getdoctitle">
               <xsl:with-param name="ascii">true</xsl:with-param>
            </xsl:call-template></xsl:variable>
         <!-- output standard html content type information -->
         <xsl:comment>standard html content type information</xsl:comment>
         <xsl:element name="meta" namespace="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="http-equiv">content-type</xsl:attribute>
            <xsl:attribute name="content">application/xhtml+xml; charset=utf-8</xsl:attribute>
         </xsl:element>
         <!-- put dublin core here? -->
         <xsl:call-template name="writehtmldc">
            <xsl:with-param name="doctitle" select="$doctitle" />
         </xsl:call-template>
         <!-- output a link to the book mark icon -->
         <xsl:comment>link to bookmark icon</xsl:comment>
         <xsl:element name="link">
            <xsl:attribute name="rel">shortcut icon</xsl:attribute>
            <xsl:attribute name="href">
               <xsl:value-of select="$faviconpath" />
            </xsl:attribute>
         </xsl:element>
         <xsl:element name="link">
            <xsl:attribute name="rel">stylesheet</xsl:attribute>
            <xsl:attribute name="type">text/css</xsl:attribute>
            <xsl:attribute name="href">
               <xsl:value-of select="$standalonecss" />
            </xsl:attribute>
         </xsl:element>
         <!-- output the standard html title for this document -->
         <xsl:comment>standard html title for this document</xsl:comment>
         <xsl:element name="title">
            <xsl:value-of select="$doctitle" />
         </xsl:element>
         <!-- output cascading stylesheet links -->
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
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
