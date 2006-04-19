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
    <xsl:template match="tei:hi">
        <xsl:choose>
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='apex'                                                                                                              -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
             <xsl:when test="@rend='apex'">
                 <xsl:element name="span">
                     <xsl:attribute name="class">apex</xsl:attribute>
                     <xsl:attribute name="title">apex over: <xsl:value-of select="."/></xsl:attribute><xsl:value-of select="translate(., 'aeiou', 'áéíóú')"/></xsl:element>
             </xsl:when>
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='intraline'                                                                                                              -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='intraline'">
                <xsl:element name="span">
                    <xsl:attribute name="class">line-through</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
           <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='italic'                                                                                                              -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='italic'">
                <xsl:element name="span">
                    <xsl:attribute name="class">italic</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
           <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='ligature'                                                                                                              -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='ligature'">
                <xsl:element name="span">
                    <xsl:attribute name="class">ligature</xsl:attribute>
                    <xsl:attribute name="title">Ligature: these characters are joined</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
           <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='normal'                                                                                                              -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='normal'">
                <xsl:element name="span">
                    <xsl:attribute name="class">normal</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
             <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='reversed'                                                                                                      -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='reversed'">
                <xsl:element name="span">
                    <xsl:attribute name="class">reversed</xsl:attribute>
                    <xsl:attribute name="title">reversed: <xsl:value-of select="."/></xsl:attribute>
                    ((<xsl:apply-templates />))
                </xsl:element>
            </xsl:when>
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='small'                                                                                                              -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='small'">
                <xsl:element name="span">
                    <xsl:attribute name="class">small</xsl:attribute>
                    <xsl:attribute  name="title">small character: <xsl:value-of select="."/></xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
          <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='strong'                                                                                                           -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='strong'">
                <xsl:element name="strong">
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='superscript'                                                                                                   -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='superscript'">
                <xsl:element name="sup">
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='supraline'                                                                                                   -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- I wonder if this should be "overline" to match css practice? TE -->
            <xsl:when test="@rend='supraline'">
                <xsl:element name="span">
                    <xsl:attribute name="class">supraline</xsl:attribute>
                    <xsl:attribute name="title">line above</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
           <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='tall'                                                                                                              -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='tall'">
                <xsl:element name="span">
                    <xsl:attribute name="class">tall</xsl:attribute>
                    <xsl:attribute  name="title">tall character: <xsl:value-of select="."/></xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- @rend='underline'                                                                                                      -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:when test="@rend='underline'">
                <xsl:element name="span">
                    <xsl:attribute name="class">underline</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:when>
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <!-- UNTRAPPED REND VALUE                                                                                           -->
            <!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
            <xsl:otherwise>
                <xsl:comment>hi tag with rend=<xsl:value-of select="@rend" /> is not supported!</xsl:comment>
                <xsl:element name="span">
                    <xsl:attribute name="class">error</xsl:attribute>
                    <xsl:attribute name="title">hi tag with rend=<xsl:value-of select="@rend" /> is not supported!</xsl:attribute>
                    <xsl:apply-templates />
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
