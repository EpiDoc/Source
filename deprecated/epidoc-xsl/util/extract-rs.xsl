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
 

<xsl:stylesheet xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xi="http://www.w3.org/2001/XInclude" version="1.0">
    <xsl:param name="rstype">foo</xsl:param>
    <xsl:param name="rsvalue">bar</xsl:param>
    <xsl:param name="divinclude">ooo</xsl:param>
    <xsl:template match="/">
        <tei:div>
            <xsl:if test="$divinclude != 'ooo'">
                <xsl:element name="xi:include">
                    <xsl:attribute name="href"><xsl:value-of select="$divinclude"/></xsl:attribute>
                </xsl:element>
            </xsl:if>
            <tei:list type="unordered">
        <xsl:apply-templates select="//tei:rs"/>
            </tei:list>
        </tei:div>
    </xsl:template>
    <xsl:template match="tei:rs">
        <xsl:if test="@type=$rstype and text() = $rsvalue">
            <xsl:apply-templates select="ancestor::tei:div[1]"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:div">
        <tei:item>
            <xsl:element name="tei:xref">
                <xsl:attribute name="href"><xsl:value-of select="@id"/>.xml</xsl:attribute>
                <xsl:value-of select="normalize-space(tei:head)"/>
            </xsl:element>
        </tei:item>

    </xsl:template>
    
</xsl:stylesheet>
