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
   <xsl:template match="tei:unclear">
      <xsl:element name="span">
         <xsl:attribute name="class">unclear-<xsl:value-of select="@reason"/></xsl:attribute>
         <xsl:attribute name="title">reason: <xsl:value-of select="@reason"/></xsl:attribute>
         <xsl:call-template name="propagateattrs"/>
         <xsl:call-template name="addsubscriptdots"><xsl:with-param name="victimstr" select="string(.)"/></xsl:call-template></xsl:element>
   </xsl:template>
   
   <xsl:template name="addsubscriptdots">
      <xsl:param name="victimstr"/>
      <xsl:choose>
         <xsl:when test="name(.) = 'mark'"><xsl:apply-templates/>&#x323;</xsl:when>
         <xsl:otherwise><xsl:call-template name="addsubscriptdotstostring"><xsl:with-param name="victimstr" select="text()"></xsl:with-param></xsl:call-template></xsl:otherwise>

      </xsl:choose>
   </xsl:template>
   <xsl:template name="addsubscriptdotstostring" 
      ><xsl:param name="victimstr"
         /><xsl:if test="string-length($victimstr) &gt; 0"
            ><xsl:variable name="firstchar" select="substring($victimstr, 1, 1)"
            /><xsl:value-of select="substring($victimstr, 1, 1)"/>&#x323;<xsl:if test="string-length($victimstr) &gt; 1"
               ><xsl:variable name="remainingchars" select="substring($victimstr, 2)" 
                  /><xsl:call-template name="addsubscriptdotstostring"><xsl:with-param name="victimstr" select="$remainingchars"/></xsl:call-template></xsl:if></xsl:if></xsl:template>
</xsl:stylesheet>
