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
   <xsl:template match="tei:g">
       <xsl:element name="span">
           <xsl:attribute name="class">mark</xsl:attribute>
           <xsl:attribute name="title">mark: <xsl:value-of select="@type"/></xsl:attribute>
           <xsl:call-template name="propagateattrs"/>
             <xsl:if test="following::*[1][local-name() = 'lb'][@type='worddiv']">
               <xsl:text>- </xsl:text>
             </xsl:if>
             <xsl:text>((</xsl:text>
             <xsl:choose>
               <xsl:when test="contains(@type, 'claudian_')">
                 <xsl:value-of select="substring-after(@type, 'claudian_')"/>
               </xsl:when>
               <xsl:otherwise>
                 <xsl:value-of select="@type"/>
               </xsl:otherwise>
             </xsl:choose>
             <xsl:text>))</xsl:text>
</xsl:element>
    </xsl:template>
</xsl:stylesheet>