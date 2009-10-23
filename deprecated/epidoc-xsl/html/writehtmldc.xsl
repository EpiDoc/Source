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
    <xsl:template name="writehtmldc">
        <xsl:param name="doctitle"/>
        <xsl:call-template name="writehtmldcprefix"/>
 
        <xsl:comment>Dublin Core metadata</xsl:comment>
        
        <xsl:element name="link" namespace="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="rel">schema.DC</xsl:attribute>
            <xsl:attribute name="href">http://purl.org/dc</xsl:attribute>
        </xsl:element>
        
        <xsl:call-template name="writehtmlmeta">
            <xsl:with-param name="name">DC.title</xsl:with-param>
            <xsl:with-param name="content"><xsl:value-of select="$doctitle"/></xsl:with-param>
        </xsl:call-template>
        
        <xsl:comment>WARNING: the named template writehtmldc does not currently write out all of the appropriate Dublin Core metadata tags</xsl:comment>
        <xsl:call-template name="writehtmldcpostfix"/>
    </xsl:template>
    
    <xsl:template name="writehtmldcprefix"/>
    <xsl:template name="writehtmldcpostfix"/>
</xsl:stylesheet>
