<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xml="http://www.w3.org/XML/1998/namespace">
   <!-- epidoc-teiheader -->
   <!-- 2005-08-10: created by Tom Elliott -->
   <xsl:import href="xmlcomment.xsl" />
   <xsl:import href="tei2.xsl" />
   <xsl:import href="teiheader.xsl" />
   <xsl:import href="teitext.xsl" />
   <xsl:import href="teibody.xsl" />
   <xsl:import href="text.xsl" />
   <xsl:import href="teihead.xsl" />
   <xsl:import href="teidiv.xsl" />
   <xsl:import href="teidiv-epidocedition.xsl" />
   <xsl:import href="teiab.xsl" />
   <xsl:import href="teilb.xsl" />
   <xsl:import href="teipersname.xsl" />
   <xsl:import href="teiplacename.xsl" />
   <xsl:import href="teiexpan.xsl" />
   <xsl:import href="teisuppliedreasonabbreviation.xsl" />
   <xsl:import href="teisicandcorr.xsl" />
   <xsl:import href="teip.xsl" />
    <xsl:import href="teispace.xsl"/>
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
   <xsl:import href="teiatt.xsl"/>
   <xsl:import href="teiunclear.xsl" />
   <xsl:import href="teixref.xsl" />
   <xsl:import href="teilistbibl.xsl" />
   <xsl:import href="teibibl.xsl" />
   <xsl:import href="teiauthor.xsl" />
   <xsl:import href="teirespstmt.xsl" />
   <xsl:import href="teiref.xsl" />
   <xsl:import href="getdivid.xsl" />
   <xsl:import href="teigap.xsl"/>
   <xsl:import href="dohtmlheadboilerplate.xsl" />
   <xsl:import href="dohtmlbodyboilerplate.xsl" />
   <xsl:import href="teititle.xsl"/>
    <xsl:import href="repeatstring.xsl"/>
   <xsl:param name="stripcomments">false</xsl:param>
   <xsl:param name="persnameuriprefix">people.html</xsl:param>
   <xsl:param name="placenameuriprefix">places.html</xsl:param>
   <xsl:param name="linenumberinterval">5</xsl:param>
   <xsl:param name="faviconpath">img/favicon.ico</xsl:param>
      <xsl:param name="screencsspath">epidocscreen.css</xsl:param>
   <xsl:param name="printcsspath">epidocprint.css</xsl:param>
   <xsl:param name="htmlcontentdivid">htmlcontent</xsl:param>
   <xsl:param name="htmlheaderdivid">htmlheader</xsl:param>
   <xsl:param name="htmlseparatordivid">htmlnavigation</xsl:param>
   <xsl:param name="vestigemark">+</xsl:param>
    <xsl:param name="gapmaxrepeat">3</xsl:param>
   <xsl:template match="/">
      <xsl:element name="html">
         <xsl:apply-templates />
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
