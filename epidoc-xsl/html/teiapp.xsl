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
	<xsl:template match="tei:app">
		<xsl:choose>
			<xsl:when
				test="contains(ancestor::tei:div/@type, 'edition') and tei:rdg/tei:add[@place='overstrike']">
				<xsl:call-template name="overstruck"/>
			</xsl:when>
			<xsl:when
				test="count(tei:rdg) = 2 and tei:rdg[1]/tei:gap[@reason='lost'] and not(tei:rdg[2]/tei:gap[@reason='lost'])">
				<xsl:call-template name="previouslyread"/>
			</xsl:when>
			<xsl:when test="tei:rdg[@n='default']">
				<xsl:apply-templates select="tei:rdg[@n='default']"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:if test="@loc"><xsl:value-of select="@loc"/>: </xsl:if><xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:note[ancestor::tei:rdg]">
		(<xsl:apply-templates/>)</xsl:template>
	
	<xsl:template match="tei:lem">
		<xsl:value-of select="."/>: 
	</xsl:template>
	
	<xsl:template match="tei:rdg">
		<xsl:value-of select="@resp"/>: <xsl:apply-templates/><xsl:if test="position() != last()">; </xsl:if>
	</xsl:template>

	<xsl:template name="overstruck">
		<xsl:element name="span">
			<xsl:attribute name="class">overstruck</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:choose>
					<xsl:when test="tei:rdg/tei:del/tei:gap[@extent='1' and @unit='character']">overstruck
						character: original character illegible</xsl:when>
					<xsl:when test="tei:rdg/tei:del/tei:unclear">overstruck character: original character
						unclear, possibly <xsl:value-of select="tei:rdg/tei:del/tei:unclear"/></xsl:when>
					<xsl:when test="tei:rdg/tei:del/text()">overstruck character: original character is clear:
							<xsl:value-of select="tei:rdg/tei:del"/></xsl:when>
					<xsl:otherwise>overstruck character: details not trapped by teiapp.xsl</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute> &lt;&lt;<xsl:apply-templates select="tei:rdg/tei:add/node()"
			/>&gt;&gt;</xsl:element>

	</xsl:template>
	<xsl:template name="previouslyread">
		<xsl:element name="span">
			<xsl:attribute name="class">previously-read</xsl:attribute>
			<xsl:attribute name="title">characters, not now visible, previously read by <xsl:value-of
					select="tei:rdg[2]/@resp"/>: <xsl:value-of select="tei:rdg[2]"/></xsl:attribute>
			<xsl:apply-templates select="tei:rdg[2]/node()"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
