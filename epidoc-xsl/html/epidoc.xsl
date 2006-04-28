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
    <!-- epidoc-teiheader -->
    <!-- 2005-08-10: created by Tom Elliott -->
    <xsl:import href="epidocmark.xsl" />
    <xsl:import href="xmlcomment.xsl" />
    <xsl:import href="tei2.xsl" />
    <xsl:import href="teiheader.xsl" />
    <xsl:import href="teiapp.xsl" />
    <xsl:import href="teitext.xsl" />
    <xsl:import href="teibody.xsl" />
    <xsl:import href="teinote.xsl"/>
    <xsl:import href="text.xsl" />
    <xsl:import href="teiadd.xsl" />
    <xsl:import href="teidel.xsl" />
    <xsl:import href="teihead.xsl" />
    <xsl:import href="teidiv.xsl" />
    <xsl:import href="teidiv-epidocedition.xsl" />
    <xsl:import href="teiab.xsl" />
    <xsl:import href="teilb.xsl" />
    <xsl:import href="teiforeign.xsl" />
    <xsl:import href="teisuppliedreasonsubaudible.xsl" />
    <xsl:import href="teisuppliedreasonlost.xsl" />
    <xsl:import href="teipersname.xsl" />
    <xsl:import href="teiplacename.xsl" />
    <xsl:import href="teiabbr.xsl" />
    <xsl:import href="teiorig.xsl" />
    <xsl:import href="teiexpan.xsl" />
    <xsl:import href="processitemchildren.xsl"/>
    <xsl:import href="teisuppliedreasonabbreviation.xsl" />
    <xsl:import href="teisuppliedreasonexplanation.xsl" />
    <xsl:import href="teisicandcorr.xsl" />
    <xsl:import href="teip.xsl" />
    <xsl:import href="teimeasure.xsl" />
    <xsl:import href="teinum.xsl" />
    <xsl:import href="teispace.xsl" />
    <xsl:import href="writehtmlmeta.xsl" />
    <xsl:import href="writehtmldc.xsl" />
    <xsl:import href="getdoctitle.xsl" />
    <xsl:import href="getdocid.xsl" />
    <xsl:import href="getid.xsl" />
    <xsl:import href="lowercase.xsl" />
    <xsl:import href="propagateattrs.xsl" />
    <xsl:import href="processgloss.xsl" />
    <xsl:import href="dolinenumbering.xsl" />
    <xsl:import href="doteiheadermetadata.xsl" />
    <xsl:import href="dolangattr.xsl" />
    <xsl:import href="teilist.xsl" />
    <xsl:import href="teiitem.xsl" />
    <xsl:import href="teihi.xsl" />
    <xsl:import href="teitag.xsl" />
    <xsl:import href="teiatt.xsl" />
    <xsl:import href="teiunclear.xsl" />
    <xsl:import href="teixref.xsl" />
    <xsl:import href="teilistbibl.xsl" />
    <xsl:import href="teibibl.xsl" />
    <xsl:import href="teiauthor.xsl" />
    <xsl:import href="teirespstmt.xsl" />
    <xsl:import href="teiref.xsl" />
    <xsl:import href="getdivid.xsl" />
    <xsl:import href="teisocalled.xsl" />
    <xsl:import href="teigap.xsl" />
    <xsl:import href="dohtmlheadboilerplate.xsl" />
    <xsl:import href="dohtmlbodyboilerplate.xsl" />
    <xsl:import href="teititle.xsl" />
    <xsl:import href="teisuppliedreasonomitted.xsl" />
    <xsl:import href="multipartpopdown.xsl"/>
    <xsl:import href="repeatstring.xsl" />
    <xsl:param name="dotitlepage">no</xsl:param>
    <xsl:param name="stripcomments">false</xsl:param>
    <xsl:param name="persnameuriprefix">people.html</xsl:param>
    <xsl:param name="placenameuriprefix">places.html</xsl:param>
    <xsl:param name="linenumberinterval">5</xsl:param>
    <xsl:param name="faviconpath">img/favicon.ico</xsl:param>
    <xsl:param name="standalonecss"></xsl:param>
    <xsl:param name="screencsspath">epidocscreen.css</xsl:param>
    <xsl:param name="printcsspath">epidocprint.css</xsl:param>
    <xsl:param name="htmlcontentdivid">htmlcontent</xsl:param>
    <xsl:param name="htmlheaderdivid">htmlheader</xsl:param>
    <xsl:param name="htmlseparatordivid">htmlnavigation</xsl:param>
    <xsl:param name="vestigemark">+</xsl:param>
    <xsl:param name="gapmaxrepeat">3</xsl:param>
    <xsl:param name="htmltitleheaderid">htmltitlepageheader</xsl:param>
    <xsl:param name="htmltitlecontentid">htmltitlepagecontent</xsl:param>
    <xsl:param name="epidocrefurl">http://epidoc.sf.net</xsl:param>
    <xsl:param name="epidocrefstring">the EpiDoc home page</xsl:param>
    <xsl:template match="/">
        <xsl:element name="html">
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>
