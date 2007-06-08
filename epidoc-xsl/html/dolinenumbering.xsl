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
    <xsl:key name="editionlb" match="//tei:div[@type='edition']//tei:lb" use="generate-id(.)"/>
   <xsl:template name="dolinenumbering">
      <xsl:variable name="language" select="ancestor::*[@lang][last()]/@lang"></xsl:variable>
      <xsl:choose>
         <xsl:when test="@n">
            <xsl:if test="@n mod $linenumberinterval = 0">
               <xsl:element name="span">
                  <xsl:attribute name="class">linenumber</xsl:attribute>
                  <xsl:attribute name="lang"><xsl:value-of select="$language"/></xsl:attribute>
                  <xsl:attribute name="lang" namespace="http://www.w3.org/XML/1998/namespace"><xsl:value-of select="$language"/></xsl:attribute>
                  <xsl:value-of select="@n" />
               </xsl:element>
            </xsl:if>
         </xsl:when>
         <xsl:otherwise>
             <xsl:variable name="precount" select="count(preceding::tei:lb[count(key('editionlb', generate-id()))&gt;0])"/>
             <xsl:variable name="precountmod" select="count(preceding::tei:lb[count(key('editionlb', generate-id()))&gt;0]) mod $linenumberinterval"/>
            <xsl:if test="$precountmod = $linenumberinterval - 1 and $precount != 1">
               <xsl:element name="span">
                  <xsl:attribute name="class">linenumber</xsl:attribute>
                  <xsl:attribute name="lang"><xsl:value-of select="$language"/></xsl:attribute>
                  <xsl:attribute name="lang" namespace="http://www.w3.org/XML/1998/namespace"><xsl:value-of select="$language"/></xsl:attribute>
                  <xsl:value-of select="$precount+1" />
               </xsl:element>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
</xsl:stylesheet>
