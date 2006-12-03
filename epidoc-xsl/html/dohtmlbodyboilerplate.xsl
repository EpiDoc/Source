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
    
    <xsl:template name="dohtmlbodyboilerplate">
        <xsl:param name="doctitleprefix"></xsl:param>
        <xsl:param name="includenav">yes</xsl:param>
        <xsl:param name="processteiheader">yes</xsl:param>
        <!-- options: floating, no -->
        <xsl:element name="body">
            <!-- create an html div to function as the header -->
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="$htmlheaderdivid" />
                </xsl:attribute>
                <xsl:element name="h1"><xsl:value-of select="$doctitleprefix"/><xsl:call-template name="getdoctitle" /></xsl:element>
            </xsl:element>
            <!-- create an html div to function as a separator/navigation bar -->
            <xsl:if test="$includenav = 'yes'"><xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="$htmlseparatordivid" />
                </xsl:attribute>
                <xsl:element name="p">
                    <xsl:attribute name="class">abstract</xsl:attribute>
                    <xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="/*/@id"/>.xml</xsl:attribute>xml version</xsl:element>
                    ||<xsl:if test="/*/@id or /*/@n"><xsl:if test="/*/@id"> id: <xsl:value-of select="/*/@id" /></xsl:if><xsl:if test="/*/@id and /*/@n"> | </xsl:if><xsl:if test="/*/@n"> n: <xsl:value-of select="/*/@n" /></xsl:if></xsl:if>
                    <xsl:if test="count(.//tei:div) &gt; 1">||
                    <xsl:choose>
                        <xsl:when test="count(ancestor-or-self::*[@rend]) = 0 or ancestor-or-self::*[@rend][1]/@rend != 'multipart'">
                            <xsl:for-each select="/*//tei:div">
                                <xsl:if test="not(ancestor::tei:div[substring-after(@id, '-') = 'subsections'])">
                                    <xsl:element name="a">
                                        <xsl:attribute name="class">htmlnavigation</xsl:attribute>
                                        <xsl:attribute name="href">#<xsl:call-template
                                                name="getdivid" /></xsl:attribute>
                                        <xsl:choose>
                                            <xsl:when test="tei:head"><xsl:call-template name="lowercase"><xsl:with-param name="victimstring" select="tei:head" /></xsl:call-template></xsl:when>
                                            <xsl:when test="@type"><xsl:call-template name="lowercase"><xsl:with-param name="victimstring" select="@type"/></xsl:call-template></xsl:when>
                                            <xsl:otherwise><xsl:call-template name="getdivid"/></xsl:otherwise>
                                        </xsl:choose>
                                        
                                    </xsl:element>
                                    <xsl:if test="count(following::tei:div) != 0">
                                        <xsl:text> | </xsl:text>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="count(/*//tei:div) &gt; 0"><a class="htmlnavigation" href="#subsections">subsections</a></xsl:if>
                        </xsl:otherwise>
                    </xsl:choose></xsl:if>
                    || <xsl:element name="a"><xsl:attribute name="href"
                            >mailto:markup@lsv.uky.edu?subject=guidelines comment on <xsl:value-of
                            select="@id"/>.xml</xsl:attribute>post a comment</xsl:element>
                    <xsl:if test="//tei:div[@type='gl-regextest']">
                    || <a href="{/tei:div/@id}.test" target="_blank">test this page</a>
                    </xsl:if>
                    
                </xsl:element>
                <xsl:variable name="cvsname"><xsl:value-of select="substring-before(substring-after(tei:div[@type='gl-cvs']//tei:seg[@n='cvs-revision-name'], '&#x24;Name: '),'&#x24;')"/></xsl:variable>
                <xsl:choose>
                    <xsl:when test="$cvsname != '' and $cvsname != ' '"><p>Release or development version:  <xsl:value-of select="$cvsname"/></p></xsl:when>
                    <xsl:otherwise>
                        <p>Revised since last release or tag: <xsl:value-of select="substring-before(substring-after(tei:div[@type='gl-cvs']//tei:seg[@n='cvs-revision-date'], '&#x24;Date: '),'&#x24;')"/></p>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element></xsl:if>
            <!-- handle any teiHeader metadata -->
            <xsl:if test="$processteiheader = 'yes'"><xsl:call-template name="doteiheadermetadata" /></xsl:if>
            <!-- create an html div to contain the rest of the document content -->
            <xsl:element name="div">
                <xsl:attribute name="id">
                    <xsl:value-of select="$htmlcontentdivid" />
                </xsl:attribute>
                
                
                <xsl:choose>
                    <xsl:when test="ancestor-or-self::*/@rend='multipart' and tei:div">
                        <xsl:apply-templates select="*[name() != 'div' and name() != 'head']" />
                        <xsl:element name="h2"><xsl:attribute name="id"
                            >subsections</xsl:attribute>Subsections</xsl:element>
                        <xsl:element name="ul">
                            <xsl:apply-templates select="tei:div[not(@type) or not(contains(@type, 'gl-'))]"/>
                        </xsl:element>
                        <xsl:apply-templates select="tei:div[@type]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="*[name() != 'head']" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
