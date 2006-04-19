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
 

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:dir="http://apache.org/cocoon/directory/2.0" xmlns:tei="http://www.tei-c.org/ns/1.0">
   <xsl:output indent="no" />
   <xsl:param name="dodirs">no</xsl:param>
   <xsl:param name="dofiles">yes</xsl:param>
    <xsl:param name="htmllink">no</xsl:param>
   <xsl:template match="comment()|processing-instruction()">
      <xsl:copy>
         <xsl:apply-templates />
      </xsl:copy>
   </xsl:template>
   <xsl:template match="dir:directory">
      <xsl:choose>
         <xsl:when test="count(ancestor::dir:directory) = 0">
            <xsl:element name="tei:div">
               <xsl:element name="tei:head">Directory contents:</xsl:element>
               <xsl:if test="*">
                  <xsl:element name="tei:list">
                     <xsl:attribute name="type">unordered</xsl:attribute>
<xsl:apply-templates/>
                  </xsl:element>
               </xsl:if>
            </xsl:element></xsl:when>
         <xsl:when test="$dodirs='yes'">
            <xsl:element name="tei:item">
               <xsl:element name="tei:xref">
                  <xsl:attribute name="doc"><xsl:value-of select="@name" />/</xsl:attribute>
                  <xsl:value-of select="@name" />/</xsl:element> (directory) <xsl:if test="*">
                  <xsl:element name="tei:list">
                     <xsl:attribute name="type">unordered</xsl:attribute>
                     <xsl:apply-templates />
                  </xsl:element>
               </xsl:if>
            </xsl:element>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="dir:file">
      
      <xsl:if test="$dofiles='yes' and contains(@name, '.xml')"><xsl:element name="tei:item">
         
         <xsl:element name="tei:xref">
            <xsl:attribute name="doc"><xsl:value-of select="substring-before(@name, '.xml')"/></xsl:attribute>
            <xsl:value-of select="@name" />
         </xsl:element> (file, last changed: <xsl:value-of select="@date" />) </xsl:element></xsl:if>
   </xsl:template>
   <xsl:template match="*">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()" />
      </xsl:copy>
   </xsl:template>
   <xsl:template match="@*">
      <xsl:attribute name="{local-name()}">
         <xsl:value-of select="." />
      </xsl:attribute>
   </xsl:template>
</xsl:stylesheet>
