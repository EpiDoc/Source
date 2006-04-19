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
    <!-- epidoc-tei2 -->
    <!-- 2005-08-10: created by Tom Elliott -->
    <xsl:template match="tei:TEI.2">
        <xsl:choose>
            <xsl:when test="$dotitlepage = 'yes'">
                <xsl:call-template name="dohtmlheadboilerplate" />
                <xsl:element name="body">
                    <xsl:element name="div">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$htmltitleheaderid" />
                        </xsl:attribute>
                        <xsl:element name="h1">
                            <xsl:call-template name="getdoctitle" />
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="div">
                        <xsl:attribute name="id">
                            <xsl:value-of select="$htmltitlecontentid" />
                        </xsl:attribute>
                        <xsl:element name="p"><xsl:element name="em">by</xsl:element><xsl:element name="br" />
                            <xsl:for-each
                                select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author">
                                <xsl:variable name="thisname"><xsl:value-of select="." /></xsl:variable>
                                <xsl:variable name="forename"><xsl:value-of
                                    select="substring-before(., ' ')" /></xsl:variable>
                                <xsl:variable name="surname"><xsl:value-of select="substring-after(., ' ')" /></xsl:variable>
                                <xsl:variable name="sibcount">
                                    <xsl:value-of select="count(following-sibling::tei:author)" />
                                </xsl:variable>
                                
                                <xsl:value-of select="$forename" />&#160;<xsl:value-of
                                    select="$surname"/><xsl:if test="$sibcount &gt; 1">,</xsl:if><xsl:text> </xsl:text><xsl:if test="$sibcount = 1"> and </xsl:if>
                            </xsl:for-each></xsl:element>
                        <xsl:element name="p"><xsl:element name="em">with the assistance of</xsl:element><xsl:element name="br" />
                            <xsl:for-each
                                select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:respStmt">
                                <xsl:variable name="sibcount">
                                    <xsl:value-of select="count(following-sibling::tei:respStmt) + 1" />
                                </xsl:variable>
                                <xsl:apply-templates select="tei:name" />
                                <xsl:if test="$sibcount &gt; 1">,</xsl:if>
                                <xsl:text>
                        </xsl:text>
                                <xsl:if test="$sibcount = 1"><xsl:element name="br"/><xsl:element
                                    name="em">and</xsl:element></xsl:if>
                            </xsl:for-each><xsl:element name="br"/>the members of the
                            <xsl:element name="a"><xsl:attribute name="href">http://lsv.uky.edu/archives/markup.html</xsl:attribute>Markup
                            List</xsl:element></xsl:element>
                        <xsl:for-each select="tei:teiHeader/tei:fileDesc/tei:publicationStmt">
                            <xsl:apply-templates />
                        </xsl:for-each>
                        <xsl:element name="p">Latest change reflected in this copy: <xsl:for-each
                                select="//tei:seg[@n='cvs-revision-date' and text() != '&#x24;Date&#x24;']">
                                <xsl:sort order="descending" />
                                <xsl:if test="position()=1">
                                    <xsl:value-of
                                        select="substring-before(substring-after(., '&#x24;Date: '),'&#x24;')"/>
                                </xsl:if>
                            </xsl:for-each></xsl:element>
                        <xsl:element name="p">The latest information on EpiDoc, and the most recent
                            revisions to the guidelines, may be obtained from <xsl:element name="a">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="$epidocrefurl" />
                                </xsl:attribute>
                                <xsl:value-of select="$epidocrefstring" />
                            </xsl:element>.</xsl:element>
                        <xsl:element name="div"><xsl:element name="h2"><xsl:element name="a"><xsl:attribute
                            name="href">toc.html</xsl:attribute>Table of Contents</xsl:element>
                    </xsl:element></xsl:element></xsl:element>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
