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
 

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <!-- in EpiDoc orig within expan or abbr is omitted from rendered version
   THIS MARKUP IS NOW DEPRECATED; USE <am> INSTEAD (as per TEI P5) -->
   <xsl:template
      match="tei:orig[contains(ancestor::tei:div/@type, 'edition') and ancestor::tei:expan]"> </xsl:template>

   <!-- in EpiDoc, orig with [@n='unresolved'] means unresolved -->
   <xsl:template match="tei:orig[contains(@n, 'unresolved')]">
      <xsl:element name="span">
         <xsl:call-template name="propagateattrs"/>
         <xsl:attribute name="class">unintelligible</xsl:attribute>
         <span style="text-transform: uppercase ;">
            <xsl:apply-templates/>
         </span>
      </xsl:element>
   </xsl:template>

</xsl:stylesheet>
<!--
Old uppercase template follows: this deprecated because does not allow for mixed content inside <gi>orig</gi>
-->
<!--
text-transform:uppercase would probably in any case be better inserted into the EpiDoc CSS for span[class='unintelligible'] where it might degrade more elegantly
-->
<!--
          <xsl:choose>
             <xsl:when test="ancestor-or-self::*[@lang][1]/@lang='lat'">
               <xsl:value-of select="translate(text(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
             </xsl:when>
             <xsl:when test="ancestor-or-self::*[@lang][1]/@lang='grc'">
               <span style="text-transform: uppercase ;"><xsl:apply-templates/></span>
             </xsl:when>
             <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
          </xsl:choose>
-->
