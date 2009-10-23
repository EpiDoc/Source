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
 

<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template name="getdoctitle">
        <xsl:param name="ascii">false</xsl:param>
        
       
       <!-- get the document title based on the type of root element we're working with -->
       <xsl:variable name="dirtytitle">
       <xsl:choose>
          <xsl:when test="local-name(/*) = 'TEI.2'"><xsl:value-of select="/tei:TEI.2/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></xsl:when>
          <xsl:when test="local-name(/*) = 'div'"><xsl:value-of select="/tei:div/tei:head"/></xsl:when>
          <xsl:otherwise>ERROR: the getdoctitle template does not support processing of root elements with the name <xsl:value-of select="name(/*)"/></xsl:otherwise>
       </xsl:choose>
       </xsl:variable>

       <!-- output the result -->
       <xsl:comment>WARNING: the named template getdoctitle does not currently handle the 'ascii' parameter: values returned may include characters beyond base ascii</xsl:comment>
       <xsl:value-of select="normalize-space($dirtytitle)"/>
        
    </xsl:template>
    
</xsl:stylesheet>
