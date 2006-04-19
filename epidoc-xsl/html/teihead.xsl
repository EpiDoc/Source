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
 

<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="tei:head">
        <xsl:call-template name="teiheadprefix"/>
        
        <xsl:variable name="headlevel"><xsl:value-of select="count(ancestor::tei:div)+1"/></xsl:variable>
        <xsl:variable name="htag">
            <xsl:choose>
                <xsl:when test="$headlevel &lt; 7">h<xsl:value-of select="$headlevel"/></xsl:when>
                <xsl:otherwise>6</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:element name="{$htag}">
            <xsl:call-template name="propagateattrs"/>
            <xsl:apply-templates/>
        </xsl:element>
        
        <xsl:call-template name="teiheadpostfix"/>
    </xsl:template>
    <xsl:template match="tei:head" mode="epidoc-edition"><xsl:apply-templates select="."/></xsl:template>
    
    <xsl:template name="teiheadprefix"/>
    <xsl:template name="teiheadpostfix"/>
</xsl:stylesheet>
