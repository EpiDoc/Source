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
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xml="http://www.w3.org/XML/1998/namespace">

    <xsl:import href="dohtmlheadboilerplate.xsl"/>
    <xsl:import href="getdoctitle.xsl"/>
    <xsl:import href="writehtmldc.xsl"/>
    <xsl:import href="writehtmlmeta.xsl"/>
    <xsl:import href="sitemapteitext.xsl"/>
    <xsl:import href="dohtmlbodyboilerplate.xsl"/>
    <xsl:import href="getdivid.xsl"/>
    <xsl:import href="lowercase.xsl"/>
    <xsl:import href="doteiheadermetadata.xsl"/>
    <xsl:import href="dolangattr.xsl"/>
        <xsl:import href="sitemapteidiv.xsl"/>
    <xsl:import href="multipartpopdown.xsl"/>
    <xsl:param name="faviconpath">img/favicon.ico</xsl:param>
    <xsl:param name="standalonecss"></xsl:param>
    <xsl:param name="screencsspath">epidocscreen.css</xsl:param>
    <xsl:param name="printcsspath">epidocprint.css</xsl:param>
    <xsl:param name="htmlheaderdivid">htmlheader</xsl:param>
    <xsl:param name="htmlseparatordivid">htmlnavigation</xsl:param>
    <xsl:param name="htmlcontentdivid">htmlcontent</xsl:param> 
    <xsl:param name="sitemaptitleprefix">Table of Contents: </xsl:param>
    <xsl:template match="/tei:TEI.2">
        <xsl:element name="html">
            <xsl:call-template name="dohtmlheadboilerplate">
                <xsl:with-param name="doctitleprefix"><xsl:value-of select="$sitemaptitleprefix"/></xsl:with-param>
            </xsl:call-template>
            <xsl:apply-templates select="tei:text"/>
            
        </xsl:element>
    </xsl:template>
    

</xsl:stylesheet>
