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
    <xsl:template match="tei:div">
        <xsl:choose>
		  <xsl:when test="@type='gl-regextest'">
		  <!-- NOTE: TEMPORARILY OMITTING REGEXTEST UNTIL IT WORKS -->
		  </xsl:when>
            <xsl:when test="count(ancestor::*) = 0">
                <xsl:call-template name="dohtmlheadboilerplate" />
                <xsl:call-template name="dohtmlbodyboilerplate" />
            </xsl:when>
            <xsl:when test="ancestor::tei:div[@rend][1]/@rend='multipart' or (count(ancestor::tei:div[@rend]) = 0 and ancestor::tei:TEI.2/@rend='multipart') ">
                <xsl:choose>
                    <xsl:when test="@id and not(contains(ancestor-or-self::tei:div/@type, 'gl-')) and not(not(@rend) and not(../@rend))">
                        <xsl:call-template name="multipartpopdown"/>
                    </xsl:when>
                    <xsl:when test="@type and contains(@type, 'gl-') and count(ancestor::tei:div) &gt; 1"/>
                    <xsl:otherwise>
                        <xsl:element name="div">
                            <xsl:call-template name="propagateattrs"/>
                            <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
                            <xsl:apply-templates/></xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- this div is part of a TEI.2 document or is a subordinate div -->
                <xsl:choose>
                    <xsl:when test="not(@type) or @type != 'gl-edition'">
                        <xsl:element name="div">
                            <xsl:call-template name="propagateattrs"/>
                            <xsl:if test="@type"><xsl:attribute name="class"><xsl:value-of select="@type"/></xsl:attribute></xsl:if>
                            <xsl:apply-templates/></xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- make div for human-readable version of encoding -->
                        <xsl:element name="div">
                            <xsl:attribute name="class">gl-encoding</xsl:attribute>
                            <xsl:element name="h3">EpiDoc Encoding</xsl:element>
                            <xsl:element name="ol">
                                <xsl:for-each select="./tei:list/tei:item">
                                    <xsl:element name="li"><xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute><xsl:apply-templates mode="process-item-children"/></xsl:element>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                        <!-- make div for xslt processing as an edition -->
                        <xsl:element name="div">
                            <xsl:call-template name="propagateattrs"/>
                            <xsl:attribute name="class">gl-edition</xsl:attribute>
                            <xsl:apply-templates/>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

</xsl:stylesheet>
