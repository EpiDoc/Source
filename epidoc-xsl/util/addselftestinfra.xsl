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
 

<xsl:stylesheet version="1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:output indent="no" doctype-system="http://seneca.stoa.org/epidoc/dtd/dev/tei-epidoc.dtd" encoding="UTF-8" omit-xml-declaration="no"/>
        <xsl:variable name="encodingdivcount" select="count(//tei:div[@type='gl-encoding'])"/>
        <xsl:variable name="typographicdivcount" select="count(//tei:div[@type='gl-typographic'])"/>
        <xsl:variable name="editiondivcount" select="count(//tei:div[@type='gl-edition'])"/>
        <xsl:variable name="regexitemprefix">Regex</xsl:variable>
        <xsl:variable name="editionitemprefix">EncEx</xsl:variable>
        <xsl:variable name="typoitemprefix">TypoEx</xsl:variable>
        <xsl:variable name="linkidprefix">TestLink</xsl:variable>
    <xsl:variable name="regexlinktype">regextest</xsl:variable>
    <xsl:template match="tei:div[not(ancestor::*)]">
        <xsl:copy>
            <xsl:apply-templates select="tei:head"/><xsl:text>
</xsl:text>
        <xsl:choose>
                <xsl:when test="$encodingdivcount != $typographicdivcount or $typographicdivcount != $editiondivcount or $encodingdivcount != $editiondivcount">
                   <p type="regexerror">divcount mismatch</p>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="//tei:div[@type='gl-encoding']">
                        <xsl:variable name="divi" select="count(preceding::tei:div[@type='gl-encoding']) + 1"/>
                        <xsl:choose>
                            <xsl:when test="not(//tei:div[@type='gl-typographic'][$divi])">
                                <p type="regexerror">no matching typographic div[<xsl:value-of select="$divi"/>]</p>
                            </xsl:when>
                            <xsl:when test="not(//tei:div[@type='gl-edition'][$divi])">
                                <p type="regexerror">no matching edition div[<xsl:value-of select="$divi"/>]</p>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="encodingitemcount" select="count(.//tei:item)"/>
                                <xsl:variable name="editionitemcount" select="count(//tei:div[@type='gl-edition'][$divi]//tei:item)"/>
                                <xsl:variable name="typographicitemcount" select="count(//tei:div[@type='gl-typographic'][$divi]//tei:item/tei:list/tei:item)"/>
                                <xsl:choose>
                                    <xsl:when test="$encodingitemcount != $editionitemcount">
                                        <p type="regexerror">for divset <xsl:value-of select="$divi"/>: encodingitemcount != editionitemcount</p>
                                    </xsl:when>
                                    <xsl:when test="$editionitemcount != $typographicitemcount">
                                        <p type="regexerror">for divset <xsl:value-of select="$divi"/>: editionitemcount != typographicitemcount</p>
                                    </xsl:when>
                                    <xsl:when test="$encodingitemcount != $typographicitemcount">
                                        <p type="regexerror">for divset <xsl:value-of select="$divi"/>: encodingitemcount != typographicitemcount</p>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                 </xsl:otherwise>
        </xsl:choose>
            <xsl:apply-templates select="*[not(name()='head')]"/>
        </xsl:copy><xsl:text>
</xsl:text>
    </xsl:template>
    
    <xsl:template match="comment()|processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy><xsl:text>
        </xsl:text></xsl:template>
     <xsl:template match="tei:item[ancestor::tei:div/@type='gl-typographic' and ancestor::tei:item/tei:bibl]">
        <xsl:copy>
            <xsl:attribute name="id"><xsl:value-of select="$typoitemprefix"/>-<xsl:value-of select="count(preceding::tei:item[ancestor::tei:item/tei:bibl])+1"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:item[ancestor::tei:div/@type='gl-edition']">
        <xsl:copy>
            <xsl:attribute name="id"><xsl:value-of select="$editionitemprefix"/>-<xsl:value-of select="count(preceding-sibling::tei:item)+ 1"/></xsl:attribute>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:div[@type='gl-encoding']">
        <xsl:variable name="divi" select="count(preceding::tei:div[@type='gl-encoding']) + 1"/>
        <xsl:variable name="itemcount" select="count(.//tei:item)"/>
        <xsl:element name="div" >
            <xsl:attribute name="id"><xsl:value-of select="/tei:div/@id"/>-regex<xsl:if test="$encodingdivcount &gt; 1">-<xsl:value-of select="$divi"/></xsl:if></xsl:attribute>
            <xsl:attribute name="type">gl-regextest</xsl:attribute><xsl:text>
  </xsl:text>
            <xsl:element name="head" >Regular Expression Test</xsl:element><xsl:text>
            </xsl:text>
            <!-- add the Regex list -->
            <xsl:element name="list">
                <xsl:call-template name="additem">
                    <xsl:with-param name="n" select="$itemcount"/>
                    <xsl:with-param name="i">1</xsl:with-param>
                    <xsl:with-param name="idprefix"><xsl:value-of select="$regexitemprefix"/><xsl:if test="$divi &gt; 1">-<xsl:value-of select="$divi"/></xsl:if></xsl:with-param> 
                </xsl:call-template>
            </xsl:element>
            <!-- build the links -->
            <xsl:call-template name="addlink">
                <xsl:with-param name="n" select="$itemcount"/>
                <xsl:with-param name="i">1</xsl:with-param>
                <xsl:with-param name="type"><xsl:value-of select="$regexlinktype"/></xsl:with-param>
                <xsl:with-param name="idprefix"><xsl:value-of select="$linkidprefix"/><xsl:if test="$divi &gt; 1">-<xsl:value-of select="$divi"/></xsl:if></xsl:with-param>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>
    <xsl:template match="*">
        <xsl:copy><xsl:apply-templates select="@*|node()"/></xsl:copy>
    </xsl:template>
    <xsl:template match="@*"><xsl:copy><xsl:apply-templates/></xsl:copy></xsl:template>
    
    <xsl:template name="additem">
        <xsl:param name="n"/>
        <xsl:param name="i"/>
        <xsl:param name="idprefix"/>
        <xsl:element name="item">
            <xsl:call-template name="additemid">
                <xsl:with-param name="i" select="$i"/>
                <xsl:with-param name="idprefix" select="$idprefix"/>
            </xsl:call-template>
            blah</xsl:element><xsl:text>
</xsl:text>
        <xsl:if test="$i &lt; $n">
            <xsl:call-template name="additem">
                <xsl:with-param name="n" select="$n"/>
                <xsl:with-param name="i" select="$i + 1"/>
                <xsl:with-param name="idprefix" select="$idprefix"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="additemid">
        <xsl:param name="i"/>
        <xsl:param name="idprefix"/>
        <xsl:attribute name="id"><xsl:value-of select="$idprefix"/>-<xsl:value-of select="$i"/></xsl:attribute>
    </xsl:template>
    <xsl:template name="addlink">
        <xsl:param name="n"/>
        <xsl:param name="i"/>
        <xsl:param name="type"/>
        <xsl:param name="idprefix"/>
        <xsl:element name="link">
            <xsl:attribute name="id"><xsl:value-of select="$idprefix"/>-<xsl:value-of select="$i"/></xsl:attribute>
            <xsl:attribute name="type"><xsl:value-of select="$type"/></xsl:attribute>
            <xsl:variable name="idshred" select="substring-after($idprefix, '-')"/>
            <xsl:choose>
                <xsl:when test="$idshred = ''">
                    <xsl:attribute name="targets"><xsl:value-of select="$typoitemprefix"/>-<xsl:value-of select="$i"/><xsl:text> </xsl:text><xsl:value-of select="$editionitemprefix"/>-<xsl:value-of select="$i"/><xsl:text> </xsl:text><xsl:value-of select="$regexitemprefix"/>-<xsl:value-of select="$i"/></xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="targets"><xsl:value-of select="$typoitemprefix"/>-<xsl:value-of select="$idshred"/>-<xsl:value-of select="$i"/><xsl:text> </xsl:text><xsl:value-of select="$editionitemprefix"/>-<xsl:value-of select="$idshred"/>-<xsl:value-of select="$i"/><xsl:text> </xsl:text><xsl:value-of select="$regexitemprefix"/>-<xsl:value-of select="$idshred"/>-<xsl:value-of select="$i"/></xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
