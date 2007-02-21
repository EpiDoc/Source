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

<xsl:template match="tei:choice[@type='correction']/tei:sic">
</xsl:template>

<xsl:template match="tei:choice[@type='correction']/tei:corr">
	<xsl:text>&#x231C;</xsl:text>
		<xsl:apply-templates/>
	<xsl:text>&#x231D;</xsl:text>
</xsl:template>

   <!-- in EpiDoc, sic with no corr but [@n='superfluous'] means erroneously included -->
    <xsl:template match="tei:sic[@n='superfluous']">
       <xsl:element name="span">
          <xsl:call-template name="propagateattrs"/>
          <xsl:attribute name="class">superfluous</xsl:attribute>
          <xsl:choose>
             <xsl:when test="ancestor-or-self::*[@lang][1]/@lang='lat'">
               <xsl:text>{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
             </xsl:when>
             <xsl:when test="ancestor-or-self::*[@lang][1]/@lang='grc'">
               <xsl:text>{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
             </xsl:when>
             <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
          </xsl:choose>
       </xsl:element>
    </xsl:template>

</xsl:stylesheet>

<!-- REST OF FILE IS LEGACY CRAP -->

<!--    <xsl:template match="tei:sic[@corr]">
        <xsl:call-template name="docorrectsubstitution">
            <xsl:with-param name="sic" select="."/>
            <xsl:with-param name="corr" select="@corr"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="tei:corr[@sic]">
        <xsl:call-template name="docorrectsubstitution">
            <xsl:with-param name="sic" select="@sic"/>
            <xsl:with-param name="corr" select="."/>
        </xsl:call-template>
    </xsl:template>
    -->
    
<!--    <xsl:template name="docorrectsubstitution">
        <xsl:param name="sic"/>
        <xsl:param name="corr"/>
        <xsl:choose>
            <xsl:when test="string-length($sic) = 1 and string-length($corr) = 1">
                <xsl:element name="span"><xsl:call-template name="propagateattrs"/><xsl:attribute name="class">correction</xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$sic"/></xsl:attribute>&lt;<xsl:value-of select="$corr"/>&gt;</xsl:element>
            </xsl:when>

            <xsl:when test="string-length($sic) &gt; 0 and string-length($corr) = 0">
               <xsl:element name="span"><xsl:call-template name="propagateattrs"/><xsl:attribute name="class">correction</xsl:attribute>{<xsl:value-of select="$sic"/>}</xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="span"><xsl:call-template name="propagateattrs"/><xsl:attribute name="class">correction</xsl:attribute><xsl:attribute name="title"><xsl:value-of select="$sic"/></xsl:attribute>&#x231C;<xsl:value-of select="$corr"/>&#x231D;</xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
-->    

   <!-- in EpiDoc, sic with no corr but [@n='unintelligible'] means unintelligible 
    <xsl:template match="tei:sic[@n='unintelligible']">
       <xsl:element name="span">
          <xsl:call-template name="propagateattrs"/>
          <xsl:attribute name="class">unintelligible</xsl:attribute>
          <xsl:choose>
             <xsl:when test="ancestor-or-self::*[@lang][1]/@lang='lat'">
               <xsl:value-of select="translate(text(), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
             </xsl:when>
             <xsl:when test="ancestor-or-self::*[@lang][1]/@lang='grc'">
               <span style="text-transform: uppercase ;"><xsl:apply-templates/></span>
             </xsl:when>
             <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
          </xsl:choose>
       </xsl:element>
    </xsl:template>
    -->

